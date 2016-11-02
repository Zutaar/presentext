require 'sinatra'
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
  erb :index
end
