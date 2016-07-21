require 'sinatra'
require 'sinatra/reloader'
require_relative 'config/db'
require_relative 'models/project'
require_relative 'models/resource'
require_relative 'models/entity'
require_relative 'models/call'
require 'pry'
set :show_exceptions, false

before do
  @url = 'http://localhost:4567'
  response["Access-Control-Allow-Origin"] = "*"
end
error do
  {error:request.env['sinatra.error']}.to_json
end
options '/*' do
  response["Access-Control-Allow-Headers"] = "origin, x-requested-with, content-type"
end

helpers do
  def url
    "https://#{request.env['HTTP_HOST']}".gsub(/\?(.*)/,'')
  end
  def path
    request.path[1..-1]
  end
  def method
    m = params[:method] || 'GET'
    m.upcase
  end
  def link path
    paths = path.split("/")
    psofar = ''
    paths.map{|p|
      psofar += "/" + p
      "<a href='#{psofar}'>#{p}</a>"
    }.join("/")
  end
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
  @entity.update(content: params.except!("splat","captures","project_id","resource","entity_id"))
  Call.create(method: method)
  @entity.to_json
end

get '/:project_id/:resource.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  Call.create(method: method)
  @resource.entities.to_json
end

post '/:project_id/:resource.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  Call.create(method: method)
  e = @resource.entities.create(content: params.except!("splat","captures","project_id","resource"))
  e.to_json
end

get '/:project_id/:resource' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @data = @resource.entities
  erb :'resources/index'
end

get '/:project_id' do
  @project = Project.find_by(sha:params[:project_id])
  erb :'projects/show'
end

post '/:project_id' do
  @project = Project.find_by(sha:params[:project_id])
  r = @project.resources.create(title: params[:title])
  Call.create(method: method)
  r.to_json
end

delete '/:project_id' do
  @project = Project.find_by(sha:params[:project_id])
  @project.destroy
  Call.create(method: method)
  redirect "/"
end



post '/' do
  p = Project.create
  Call.create(method: method)
  redirect p.sha
end