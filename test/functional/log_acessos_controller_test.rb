require 'test_helper'

class LogAcessosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:log_acessos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_log_acesso
    assert_difference('LogAcesso.count') do
      post :create, :log_acesso => { }
    end

    assert_redirected_to log_acesso_path(assigns(:log_acesso))
  end

  def test_should_show_log_acesso
    get :show, :id => log_acessos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => log_acessos(:one).id
    assert_response :success
  end

  def test_should_update_log_acesso
    put :update, :id => log_acessos(:one).id, :log_acesso => { }
    assert_redirected_to log_acesso_path(assigns(:log_acesso))
  end

  def test_should_destroy_log_acesso
    assert_difference('LogAcesso.count', -1) do
      delete :destroy, :id => log_acessos(:one).id
    end

    assert_redirected_to log_acessos_path
  end
end
