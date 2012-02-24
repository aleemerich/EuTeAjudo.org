require 'test_helper'

class DialogosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:dialogos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_dialogo
    assert_difference('Dialogo.count') do
      post :create, :dialogo => { }
    end

    assert_redirected_to dialogo_path(assigns(:dialogo))
  end

  def test_should_show_dialogo
    get :show, :id => dialogos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => dialogos(:one).id
    assert_response :success
  end

  def test_should_update_dialogo
    put :update, :id => dialogos(:one).id, :dialogo => { }
    assert_redirected_to dialogo_path(assigns(:dialogo))
  end

  def test_should_destroy_dialogo
    assert_difference('Dialogo.count', -1) do
      delete :destroy, :id => dialogos(:one).id
    end

    assert_redirected_to dialogos_path
  end
end
