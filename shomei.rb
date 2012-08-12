#!/usr/bin/env ruby -w
# encoding: UTF-8
lib_path = File.expand_path('../lib', __FILE__)
($:.unshift lib_path) unless ($:.include? lib_path)

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
  
  if Ping.create machine: ping["machine"], status: ping["status"]
    status 201
    return ":)"
  end
end

error 500 do
  ":("
end
