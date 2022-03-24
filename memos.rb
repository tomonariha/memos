# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'cgi'

class Memo 
  @connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')

  def create(id, title, content)
    { id: id, title: title, content: content }
  end  

  def all
    @connect.exec('SELECT * FROM memos ORDER BY id ASC')
  end  

  def detail(id)
    @connect.exec('SELECT * FROM memos WHERE id = $1', id)
  end  

  def save(memo)
    @connect.exec('INSERT INTO memos(title, content) VALUES ($1, $2)', [memo[:title], memo[:content]])
  end  

  def update(memo)
    @connect.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3',
                 [memo[:title], memo[:content], memo[:id]])
  end  

  def destroy(id)
    @connect.exec('DELETE FROM memos WHERE id = $1', id)
  end
end

memos = Memo.new

get '/memos' do
  @memos = memos.all
  @title = 'index'
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  @memo = memos.detail([params[:id]])
  @title = 'detail'
  erb :detail
end

post '/memos' do
  memo = memos.create(params[:id], params[:title], params[:content])
  memos.save(memo)
  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = memos.detail([params[:id]])
  @title = 'edit'
  erb :edit
end

patch '/memos/:id' do
  memo = memos.create(params[:id], params[:title], params[:content])
  memos.update(memo)
  redirect '/memos'
end

delete '/memos/:id' do
  memos.destroy([params[:id]])
  redirect '/memos'
end
