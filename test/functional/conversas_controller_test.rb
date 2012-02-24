require 'test_helper'

class ConversasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:conversas)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_conversa
    assert_difference('Conversa.count') do
      post :create, :conversa => { }
    end

    assert_redirected_to conversa_path(assigns(:conversa))
  end

  def test_should_show_conversa
    get :show, :id => conversas(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => conversas(:one).id
    assert_response :success
  end

  def test_should_update_conversa
    put :update, :id => conversas(:one).id, :conversa => { }
    assert_redirected_to conversa_path(assigns(:conversa))
  end

  def test_should_destroy_conversa
    assert_difference('Conversa.count', -1) do
      delete :destroy, :id => conversas(:one).id
    end

    assert_redirected_to conversas_path
  end
end
