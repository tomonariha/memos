# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'cgi'

def generate_memos(id)
  @memos = { 'memo_id': id, 'title': params['title'], 'content': params['content'] }
end

def load_all_memos
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  @memos = connect.exec('select * from memos order by memo_id asc')
end

def load_detail_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  @memos = connect.exec('select * from memos where memo_id = $1', [params[:id].to_i])
end

def save_new_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  connect.exec('insert into memos values ($1, $2, $3)', [@memos[:memo_id], @memos[:title], @memos[:content]])
end

def update_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  connect.exec('update memos set title = $1, content = $2 where memo_id = $3',
               [@memos[:title], @memos[:content], @memos[:memo_id]])
end

def delete_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  connect.exec('delete from memos where memo_id = $1', [params[:id]])
end

get '/memos' do
  load_all_memos
  @title = 'index'
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  load_detail_memo
  @title = 'detail'
  erb :detail
end

post '/memos' do
  generate_memos(object_id)
  save_new_memo
  redirect '/memos'
end

get '/memos/:id/edit' do
  load_detail_memo
  @title = 'edit'
  erb :edit
end

patch '/memos/:id' do
  generate_memos(params[:id])
  update_memo
  redirect '/memos'
end

delete '/memos/:id' do
  delete_memo
  redirect '/memos'
end
