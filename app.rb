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

def load_items
  File.write(DATA_FILE, JSON.pretty_generate([])) unless File.exist?(DATA_FILE)
  JSON.parse(File.read(DATA_FILE), symbolize_names: true)
end

def save_items(items)
  File.write(DATA_FILE, JSON.pretty_generate(items))
end

def find_item(items, id)
  items.find { |item| item[:id] == id }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @items = load_items
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  items = load_items
  new_id = items.empty? ? 1 : items.last[:id] + 1

  items << {
    id: new_id,
    title: params[:title],
    body: params[:body]
  }

  save_items(items)
  redirect '/memos'
end

get '/memos/:id' do
  @item = find_item(load_items, params[:id].to_i)
  erb :show
end

get '/memos/:id/edit' do
  @item = find_item(load_items, params[:id].to_i)
  erb :edit
end

patch '/memos/:id' do
  items = load_items
  item = find_item(items, params[:id].to_i)

  item[:title] = params[:title]
  item[:body] = params[:body]

  save_items(items)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  items = load_items.reject { |item| item[:id] == params[:id].to_i }
  save_items(items)
  redirect '/memos'
end

not_found do
  '404 Not Found'
end
