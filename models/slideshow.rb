require 'active_record'

class Slideshow < ActiveRecord::Base
  validates :title, uniqueness: true
end
