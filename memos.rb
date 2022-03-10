# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'

def save_file
  File.open('public/json/data.json', 'w') { |file| JSON.dump(@data, file) }
end

def load_file
  File.open('public/json/data.json') { |file| @data = JSON.load(file) }
end

def generate_data(id)
  @data[id] = { 'title': params['title'], 'body': params['body'] }
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
  generate_data(object_id.to_s)
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
  generate_data(params[:id].to_s)
  save_file
  redirect '/memos'
end

delete '/memos/:id' do
  load_file
  @data.delete(params[:id].to_s)
  save_file
  redirect '/memos'
end
