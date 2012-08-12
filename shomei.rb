#!/usr/bin/env ruby -w
# encoding: UTF-8
lib_path = File.expand_path('../lib', __FILE__)
($:.unshift lib_path) unless ($:.include? lib_path)

require 'rack/conneg'
require 'sinatra'
require 'multi_json'
require 'data_mapper'
require 'dm-timestamps'
require 'dotenv'
Dotenv.load

DataMapper.setup(:default, ENV['DATABASE_URL'])
require 'models/ping'
DataMapper.finalize
DataMapper.auto_upgrade!

configure :development do |config|
  require "sinatra/reloader"
  config.also_reload "lib/models/*.rb"
end

before do
  if request.negotiated?
    content_type request.negotiated_type
  end
end

get '/' do
  erb :index
end

get '/pings' do
  col = params[:col] || "created_at"
  sort = params[:sort] || "asc"

  @pings = Ping.all(:order => col.to_sym.send(sort.to_sym))
  
  Sinatra::Application.respond_to do |wants|
    wants.json  { @pings.to_json }
    wants.html  { erb :pings, layout: false }
    wants.other { content_type 'text/plain' ; error 406, "Not Acceptable" }
  end
end

post '/pings' do
  return 500 unless params[:ping]

  begin
    ping = MultiJson.load params[:ping], symbolize_keys: true 
    if Ping.create ping
      status 201
      return ":)"
    end
  rescue 
    return 500
  end
end

error 500 do
  ":("
end
