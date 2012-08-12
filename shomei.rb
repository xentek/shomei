#!/usr/bin/env ruby -w
# encoding: UTF-8

require 'sinatra'
require 'multi_json'
require 'require_all'
require_all 'lib/models'

configure :development do |config|
  require "sinatra/reloader"
  config.also_reload "lib/models/*.rb"
end

get '/' do
  erb :index
end

post '/pings' do
  return 500 unless params[:ping]

  begin
    ping = MultiJson.load(params[:ping]) 
  rescue 
    return 500
  end
  
  if Ping.create ping["machine"], ping["status"]
    status 201
    return ":)"
  end
end

error 500 do
  ":("
end
