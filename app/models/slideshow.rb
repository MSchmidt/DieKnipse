class Slideshow < ActiveRecord::Base
  has_many :slides, :dependent => :destroy
end
