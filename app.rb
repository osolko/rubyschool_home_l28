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
    @db.execute 'CREATE TABLE IF NOT EXISTS Posts (
                                                    id INTEGER  PRIMARY KEY AUTOINCREMENT,
                                                    create_date` DATE,
                                                    content` TEXT )'
    
    @db.execute 'CREATE TABLE IF NOT EXISTS Comments (
                                                    id INTEGER  PRIMARY KEY AUTOINCREMENT,
                                                    create_date DATE,
                                                    content TEXT,
                                                    post_id INTEGER )'
end



get '/' do
    
    @results = @db.execute 'select * from Posts ORDER BY id DESC'
    erb :index
    
end



get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]
    if content.length <= 0
        @error = "Post can't be empty"
        erb :new
    else
        @db.execute 'INSERT INTO Posts (content, create_date) VALUES (?, datetime())',[content]
        
        # redirect to main after post created
        redirect to '/'
        #    erb "your post is : #{content}"
    end
end



# show post info
get '/details/:post_id' do

#отримуємо переміннуз з урл    
    post_id= params[:post_id]
# отримуємо список постів по айді    
    results = @db.execute 'select * from Posts where id =?', [post_id]
    @row = results[0]

#вивід коментарів під постом
    @comments = @db.execute 'select * from coments where post_id= ? ORDER BY id', [post_id]

    erb :details
end



# обробляємо пост запит details ^ відправка даних на сервер
post '/details/:post_id' do
    post_id = params[:post_id]
    content = params[:content]
      
    @db.execute 'INSERT INTO Comments (content, create_date, post_id) VALUES (?, datetime(), ?)', [content, post_id]

    redirect to ('/details/' + post_id)

   # erb "your comments is : #{content} for post #{post_id}"
end


