require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'presentext'
  # username: 'Leon_Falvey' # Not needed
}
# For local hosting/testing
# ActiveRecord::Base.establish_connection(options)

# When hosting on heroku
ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
