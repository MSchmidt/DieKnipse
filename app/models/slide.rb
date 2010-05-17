class Slide < ActiveRecord::Base
  belongs_to :slideshow
  
  has_attached_file :image
  
  #validates_attachment_presence :image
end
