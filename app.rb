require 'sinatra'
# For local hosting and testing
require 'sinatra/reloader'
require 'pg'


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

  def current_slideshow
    Slideshow.find_by(id: session[:slideshow_id])
  end

  def reset_slideshow
    session[:slideshow_id] = nil
  end
end

get '/' do
  reset_slideshow
  if logged_in?

    @slideshows = Slideshow.where(user_id: current_user.id)


    erb :user_home
  else

    erb :login

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
  reset_slideshow
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

  redirect to "/slideshow?id=#{slideshow.id}"
end

get '/slideshow' do
  session[:slideshow_id] = params[:id]


  @slideshow = current_slideshow

  @slides = @slideshow.content.split(/[\r\n]+/)

  # binding.pry

  erb :slideshow
end

get '/edit' do

  @slideshow = current_slideshow


  erb :slideshow_edit
end

post '/edit' do
  slideshow = current_slideshow
  slideshow.update(content: params[:content])

  redirect to "/slideshow?id=#{slideshow.id}"
end

delete '/delete' do
  slideshow = current_slideshow
  slideshow.destroy
  redirect to '/'
end

# Present the slideshow code
get '/slideshow/present' do
  @slides =
 current_slideshow.content.split(/[\r\n]+/)

  erb :slideshow_present
end
