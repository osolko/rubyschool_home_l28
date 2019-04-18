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

    erb :details
end

# обробляємо пост запит details ^ відправка даних на сервер
post '/details/:post_id' do
    post_id= params[:post_id]
    content = params[:newcomment]

    erb "your commentsis : #{content} for post #{post_id}"
     

end


