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

    erb :user_home

  else

    erb :index

  end
end

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

end
