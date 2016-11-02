require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'rpgcharacters'
  # username: 'Leon_Falvey' # Not needed
}


ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
