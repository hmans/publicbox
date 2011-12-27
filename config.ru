require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'sinatra'
require 'nokogiri'
require 'json'
require 'schnitzelstyle'
require 'rack-cache'

use Rack::Cache

class PublicBox < Sinatra::Application
  before do
    cache_control :public, :must_revalidate, :max_age => 60
  end

  get '/' do
    haml :home
  end

  get '/publicbox.css' do
    scss :publicbox
  end

  get '/*' do |path|
    doc = Nokogiri::HTML(open("https://www.dropbox.com/#{path}").read)
    files = []
    doc.css('#list-view div.filerow').each do |row|
      files << {
        filename: row.css('div.filename a').first.content.strip,
        size: row.css('div.filesize span.hidden').first.content.to_i,
        modified: row.css('div.modified span.hidden').first.content.to_i,
        url: row.css('div.filename a').first['href'].gsub(/\/\/www\./, "//dl.") + "?dl=1"
      }
    end

    content_type :json
    files.to_json
  end
end

run PublicBox
