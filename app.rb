require 'sinatra'
# For local hosting and testing
require 'sinatra/reloader'
require 'pg'
# for testing single commands
require 'pry'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/slideshow'
require_relative 'models/slide'

# binding.pry

enable :sessions

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  if logged_in?
    @slideshows = Slideshow.where(user_id: current_user.id)


    erb :user_home
  else

    erb :index

  end
end

# User related stuff

get '/signup' do
  erb :signup
end

post '/signup' do
  new_user = User.new(email: params[:email], password: params[:password])

  if new_user.save
    session[:user_id] = new_user.id

    redirect to '/'
  else

    erb :signup
  end
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id

    redirect to '/'
  else
    erb :session_new
  end
end

get '/signout' do
  session[:user_id] = nil

  redirect to '/'
end

# Slideshow related stuff

get '/new' do
  erb :new_slideshow
end

post '/new' do
  slideshow = Slideshow.new(user_id: current_user.id, title: params[:title], content: params[:content])

  slideshow.save

  redirect to '/'
  # redirect to "/edit/#{slideshow.id}"
end

get '/edit/:id' do

end
