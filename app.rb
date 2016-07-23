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

before do
  @url = 'http://localhost:4567'
  response["Access-Control-Allow-Origin"] = "*"
  response["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
  body = request.body.read
  @json = body.empty? || body.match("_method") ? {} : JSON.parse(body.to_s)
end
error do
  {error:request.env['sinatra.error']}.to_json
end
options '/*' do
  response["Access-Control-Allow-Headers"] = "origin, x-requested-with, content-type"
end

get '/' do
  @calls = Call.all.count
  erb :index
end

get '/:project_id/:resource/:entity_id.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @entity.to_json
end

get '/:project_id/:resource/:entity_id' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @data = @entity
  erb :'resources/index'
end

delete '/:project_id/:resource/:entity_id' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @entity.destroy
  Call.create(method: method)
  nil
end
patch '/:project_id/:resource/:entity_id.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @entity.update(content: @json)
  Call.create(method: method)
  @entity.to_json
end

get '/:project_id/:resource.json' do
  @project = Project.find_or_create_by(sha:params[:project_id])
  @resource = @project.resources.find_or_create_by(title: params[:resource])
  Call.create(method: method)
  (@resource.entities || []).to_json
end

post '/:project_id/:resource.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  Call.create(method: method)
  e = @resource.entities.create(content: @json)
  e.to_json
end

get '/:project_id/:resource' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @data = @resource.entities
  if request.headers["Content-type"] == "application/json"
    @data.to_json
  else
    erb :'resources/index'
  end
end

post '/:project_id' do
  @project = Project.find_by(sha:params[:project_id])
  r = @project.resources.create(title: params[:title] || @json)
  Call.create(method: method)
  r.to_json
end

post '/' do; project_create; end

get '/:project_id' do; project_show; end
get '/:project_id.json' do; project_show; end

delete '/:project_id' do; project_delete; end
delete '/:project_id.json' do; project_delete; end

def project_create
  p = Project.create
  Call.create(method: method)
  if request.env["CONTENT_TYPE"].match "application/json"
    response.headers['Content-Type'] = "application/json"
    p.to_json
  else
    redirect p.sha
  end
end

def json?
  request.env["CONTENT_TYPE"] == "application/json" || request.env["REQUEST_PATH"].match(/\.json/)
end

def project_show
  id = params[:project_id].gsub(/\.json/,'')
  @project = Project.find_by(sha:id)
  if json?
    response.headers['Content-Type'] = "application/json"
    @project.resources.to_json
  else
    erb :'projects/show'
  end
end

def project_delete
  id = params[:project_id].gsub(/\.json/,'')
  @project = Project.find_by(sha:id)
  @project.destroy
  Call.create(method: method)
  if request.env["CONTENT_TYPE"] == "application/json"
    nil
  else
    redirect "/"
  end
end