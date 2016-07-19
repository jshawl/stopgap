require 'sinatra'
require 'sinatra/reloader'
require_relative 'config/db'

get '/' do
  erb :index
end

post '/' do
  
end