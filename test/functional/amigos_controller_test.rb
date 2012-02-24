require 'test_helper'

class AmigosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:amigos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_amigo
    assert_difference('Amigo.count') do
      post :create, :amigo => { }
    end

    assert_redirected_to amigo_path(assigns(:amigo))
  end

  def test_should_show_amigo
    get :show, :id => amigos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => amigos(:one).id
    assert_response :success
  end

  def test_should_update_amigo
    put :update, :id => amigos(:one).id, :amigo => { }
    assert_redirected_to amigo_path(assigns(:amigo))
  end

  def test_should_destroy_amigo
    assert_difference('Amigo.count', -1) do
      delete :destroy, :id => amigos(:one).id
    end

    assert_redirected_to amigos_path
  end
end
