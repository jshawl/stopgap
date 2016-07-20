require 'sinatra'
require 'sinatra/reloader'
require_relative 'config/db'
require_relative 'models/project'
require_relative 'models/resource'
require_relative 'models/entity'

before do
  @url = 'http://localhost:4567'
end

get '/' do
  erb :index
end

get '/:project_id/:resource/:entity_id' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @entity = @resource.entities.find(params[:entity_id])
  erb :'resources/index'
end

get '/:project_id/:resource.json' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
  @resource.entities.to_json
end

get '/:project_id/:resource' do
  @project = Project.find_by(sha:params[:project_id])
  @resource = @project.resources.find_by(title: params[:resource])
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