#!/usr/bin/env ruby -w
# encoding: UTF-8
lib_path = File.expand_path('../lib', __FILE__)
($:.unshift lib_path) unless ($:.include? lib_path)

require 'rack/conneg'
require 'sinatra'
require 'multi_json'
require 'data_mapper'
require 'dm-timestamps'
require 'dm-aggregates'
require 'action_view'
include ActionView::Helpers::DateHelper

configure :development do |config|
  require 'dotenv'
  Dotenv.load
  require "sinatra/reloader"
  config.also_reload "lib/*.rb"
end

DataMapper.setup(:default, ENV['DATABASE_URL'])
require 'ping'
DataMapper.finalize
DataMapper.auto_upgrade!

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      halt 401, "Not authorized"
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['ADMIN_USER'], ENV['ADMIN_PASS']]
  end
end

before do
  protected!
  if request.negotiated?
    content_type request.negotiated_type
  end
end

get '/' do
  erb :index
end

get '/machines/:machine' do
  @machine = params[:machine]
  @pings = Ping.all(:machine => params[:machine], :order => [:updated_at.desc])
  halt 404, 'Not Found' if @pings.empty?
  erb :machines
end

get '/pings/:machine' do
  col = params[:col] || "updated_at"
  sort = params[:sort] || "desc"
  
  @pings = Ping.all(:machine => params[:machine], 
                    :order => [(col.to_sym).send(sort.to_sym)])
  
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
