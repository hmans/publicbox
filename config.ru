require 'rubygems'
require 'bundler/setup'
require 'sinatra'

# https://www.dropbox.com/s/timd27onyt5t5b6#view:list
# http://localhost:9393/path/s/timd27onyt5t5b6
class PublicBox < Sinatra::Application
  get '/' do
    haml :home
  end

  get '/box/*' do |path|
    "Fetching #{path}"
  end
end

run PublicBox
