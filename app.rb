#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
    @db = SQLite3::Database.new 'leprosorium.db'
    @db.results_as_hash = true
end

before do
    init_db
end

configure do
    init_db
    @db.execute 'CREATE TABLE IF NOT EXISTS `Posts` (
                    `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
                    `create_date` DATE,
                    `content` TEXT )'
end

get '/' do
    
    @results = @db.execute 'select * from Posts ORDER BY id DESC'
    erb :index
    
end



get '/new' do
  erb :new
end

post '/new' do
  content = params[:textnewpost]
  
    if content.length <= 0
        @error = "Post can't be empty"
        erb :new
    else
        @db.execute 'INSERT INTO `Posts` (content, create_date) VALUES (?, datetime())',[content]
        erb "your post is : #{content}"
    end
  
end

# comments
# comments
