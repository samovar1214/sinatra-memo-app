# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

DATA_FILE = 'items.json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  File.write(DATA_FILE, JSON.generate([])) unless File.exist?(DATA_FILE)
  JSON.parse(File.read(DATA_FILE), symbolize_names: true)
end

def save_memos(memos)
  File.write(DATA_FILE, JSON.pretty_generate(memos))
end

def find_memo(id)
  memos = load_memos
  memo  = memos.find { |m| m[:id] == id }
  [memos, memo]
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
  memos = load_memos
  new_id = memos.empty? ? 1 : memos.last[:id] + 1

  memos << {
    id: new_id,
    title: params[:title],
    body: params[:body]
  }

  save_memos(memos)
  redirect '/memos'
end

get '/memos/:id' do
  _memos, @memo = find_memo(params[:id].to_i)
  erb :show
end

get '/memos/:id/edit' do
  _memos, @memo = find_memo(params[:id].to_i)
  erb :edit
end

patch '/memos/:id' do
  memos, memo = find_memo(params[:id].to_i)

  memo[:title] = params[:title]
  memo[:body] = params[:body]

  save_memos(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos, memo = find_memo(params[:id].to_i)
  memos.delete(memo)
  save_memos(memos)
  redirect '/memos'
end

not_found do
  '404 Not Found'
end
