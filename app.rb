require 'sinatra'
# For local hosting and testing
require 'sinatra/reloader'
require 'pg'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/slideshow'
require_relative 'models/slide'

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
  if !logged_in?
    erb :index
  else

    erb :user_home
  end
end

get '/login' do

end

get '/signup' do
  
end
