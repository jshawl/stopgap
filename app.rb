require 'pry'
require 'rack'
require 'rack/contrib'
require 'sinatra'
require 'sinatra/reloader'
require_relative 'config/db'
require_relative 'models/project'
require_relative 'models/resource'
require_relative 'models/entity'
require_relative 'models/call'
require_relative 'helpers'
use Rack::PostBodyContentTypeParser
set :show_exceptions, false
enable :sessions

before do
  @url = 'http://localhost:4567'
  @sha = `git rev-list -1 HEAD public/styles.css`.gsub(/\n/,'')
  response["Access-Control-Allow-Origin"] = "*"
  response["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
  response.headers['Content-Type'] = "application/json" if json?
  body = request.body.read
  @json = body.empty? || body.match("_method") ? {} : JSON.parse(body.to_s)
end

error do
  {error:request.env['sinatra.error']}.to_json
end

options '/*' do
  response["Access-Control-Allow-Headers"] = "origin, x-requested-with, content-type"
end

def json?
  request.env["CONTENT_TYPE"] == "application/json" || request.env["REQUEST_PATH"].match(/\.json/)
end

get '/' do
  @calls = Call.all.count.to_s.split("").reverse.each_with_index.map{|d, i|
    o = d
    o += "," if i % 3 === 0 && i != 0
    o
  }.reverse.join("")
  session[:projects] ||= []
  @projects = session[:projects].map{|sha| Project.find_by(sha: sha)}.compact
  erb :index
end

get '/:project_id/:resource/:entity_id' do
  entity_show
end

delete '/:project_id/:resource/:entity_id' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @entity.destroy
  Call.create(method: method)
  nil
end
patch '/:project_id/:resource/:entity_id' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @entity.update(content: @entity.content.merge(@json))
  Call.create(method: method)
  @entity.to_json
end

get '/:project_id/:resource.json' do
  @project = Project.find_or_create_by(sha:params[:project_id])
  @resource = @project.resources.find_or_create_by(title: params[:resource])
  Call.create(method: method)
  (@resource.entities || []).to_json
end

post '/:project_id/:resource' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource].gsub(/\.json$/,''))
  Call.create(method: method)
  e = @resource.entities.create(content: @json)
  e.to_json
end

def entity_show
  begin
    @project = Project.find_by(sha:params[:project_id])
    @resource = @project.resources.find_by(title: params[:resource])
    @entity = @resource.entities.find(params[:entity_id])
    @data = @entity
    if params[:method]
      erb :"resources/#{params[:method]}"
    else
      erb :'resources/index'
    end
  rescue
    status 404
    if json?
      {error: "Not found."}.to_json
    else
      erb :'resources/404'
    end
  end
end

get '/:project_id/:resource' do; resource_show; end
post '/:project_id' do; resource_create; end

def resource_create
  @project = Project.find_by(sha:params[:project_id])
  response.headers['Content-Type'] = "application/json"
  r = @project.resources.create(title: params[:title] || @json["title"])
  Call.create(method: method)
  r.to_json
end

def resource_show
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_or_create_by(title: params[:resource])
  @data = params[:method] == "post" ?  (@resource.entities.last || {}) : @resource.entities
  if json?
    @data.to_json
  else
    if params[:method] == "post"
      erb :"resources/post"
    else
      erb :'resources/index'
    end
  end
end

post '/' do; project_create; end
get '/:project_id' do; project_show; end
delete '/:project_id' do; project_delete; end

def project_create
  p = Project.create
  session[:projects] ||= []
  session[:projects] << p.sha
  Call.create(method: method)
  if request.env["CONTENT_TYPE"] && request.env['CONTENT_TYPE'].match("x-www")
    redirect p.sha
  else
    response.headers['Content-Type'] = "application/json"
    p.to_json
  end
end


def project_show
  id = params[:project_id].gsub(/\.json/,'')
  @project = Project.find_by(sha:id)
  if @project
    if json?
      @project.resources.to_json
    else
      erb :'projects/show'
    end
  else
    status 404
    erb :'projects/404'
  end
end

def project_delete
  id = params[:project_id].gsub(/\.json/,'')
  @project = Project.where(sha:id)
  @project.destroy_all
  Call.create(method: method)
  if json?
    nil
  else
    redirect "/"
  end
end