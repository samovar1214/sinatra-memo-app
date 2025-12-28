# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

MEMOS ||= PG.connect(dbname: 'sinatra_memo_app')
MEMOS.exec('CREATE TABLE IF NOT EXISTS memos (id SERIAL PRIMARY KEY, title TEXT NOT NULL, body TEXT NOT NULL)')

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  MEMOS.exec('SELECT * FROM memos')
end

def create_memo(title, body)
  MEMOS.exec_params('INSERT INTO memos (title, body) VALUES ($1, $2)', [title, body])
end

def find_memo(id)
  memos = MEMOS.exec_params('SELECT * FROM memos WHERE id = $1', [id])
  memos[0]
end

def update_memo(id, title, body)
  MEMOS.exec_params('UPDATE memos SET title = $1, body = $2 WHERE id =$3', [title, body, id])
end

def delete_memo(id)
  MEMOS.exec_params('DELETE FROM memos WHERE id = $1', [id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  create_memo(params[:title], params[:body])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = find_memo(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])
  erb :edit
end

patch '/memos/:id' do
  update_memo(params[:id], params[:title], params[:body])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end

not_found do
  '404 Not Found'
end
