require 'test_helper'

class SlideshowsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slideshows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create slideshow" do
    assert_difference('Slideshow.count') do
      post :create, :slideshow => { }
    end

    assert_redirected_to slideshow_path(assigns(:slideshow))
  end

  test "should show slideshow" do
    get :show, :id => slideshows(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => slideshows(:one).to_param
    assert_response :success
  end

  test "should update slideshow" do
    put :update, :id => slideshows(:one).to_param, :slideshow => { }
    assert_redirected_to slideshow_path(assigns(:slideshow))
  end

  test "should destroy slideshow" do
    assert_difference('Slideshow.count', -1) do
      delete :destroy, :id => slideshows(:one).to_param
    end

    assert_redirected_to slideshows_path
  end
end
