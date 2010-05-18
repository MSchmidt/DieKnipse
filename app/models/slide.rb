require 'socket'

class Slide < ActiveRecord::Base
  belongs_to :slideshow
  has_attached_file :image
  
  #validates_attachment_presence :image
  
  def after_initialize
    @attributes["image_url"] = image.url
  end
end
