require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'sinatra'
require 'nokogiri'
require 'json'

class PublicBox < Sinatra::Application
  get '/' do
    haml :home
  end

  get '/box/*' do |path|
    doc = Nokogiri::HTML(open("https://www.dropbox.com/#{path}").read)
    files = []
    doc.css('#list-view div.filerow').each do |row|
      files << {
        filename: row.css('div.filename a').first.content.strip,
        size: row.css('div.filesize span.hidden').first.content.to_i,
        modified: row.css('div.modified span.hidden').first.content.to_i
      }
    end

    content_type :json
    files.to_json
  end
end

run PublicBox
