require 'sinatra'
require 'sinatra/reloader'
require_relative 'config/db'
require_relative 'models/project'
require_relative 'models/resource'
require_relative 'models/entity'
require 'pry'
set :show_exceptions, false

before do
  @url = 'http://localhost:4567'
end
error do
  {error:request.env['sinatra.error']}.to_json
end

helpers do
  def url
    request.url.gsub(/\?(.*)/,'')
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
  erb :index
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
  nil
end
patch '/:project_id/:resource/:entity_id.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  @entity.update(content: params.except!("splat","captures","project_id","resource","entity_id"))
  @entity.to_json
end

get '/:project_id/:resource.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @resource.entities.to_json
end

post '/:project_id/:resource.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
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

post '/' do
  p = Project.create
  redirect p.sha
end