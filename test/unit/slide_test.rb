require 'test_helper'

class SlideTest < ActiveSupport::TestCase  
  should_belong_to :slideshow
  should_have_attached_file :image
end
