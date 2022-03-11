# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'

def save_file
  File.open('public/json/data.json', 'w') { |file| JSON.dump(@memos, file) }
end

def load_file
  File.open('public/json/data.json') { |file| @memos = JSON.parse(file.read) }
end

def generate_memos(id)
  @memos[id] = { 'title': params['title'], 'body': params['body'] }
end

get '/memos' do
  load_file
  @title = 'index'
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  load_file
  @title = 'detail'
  erb :detail
end

post '/memos' do
  load_file
  generate_memos(object_id.to_s)
  save_file
  redirect '/memos'
end

get '/memos/:id/edit' do
  load_file
  @title = 'edit'
  erb :edit
end

patch '/memos/:id' do
  load_file
  generate_memos(params[:id].to_s)
  save_file
  redirect '/memos'
end

delete '/memos/:id' do
  load_file
  @memos.delete(params[:id].to_s)
  save_file
  redirect '/memos'
end
