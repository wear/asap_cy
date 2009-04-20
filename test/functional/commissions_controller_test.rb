require 'test_helper'

class CommissionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:commissions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_commission
    assert_difference('Commission.count') do
      post :create, :commission => { }
    end

    assert_redirected_to commission_path(assigns(:commission))
  end

  def test_should_show_commission
    get :show, :id => commissions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => commissions(:one).id
    assert_response :success
  end

  def test_should_update_commission
    put :update, :id => commissions(:one).id, :commission => { }
    assert_redirected_to commission_path(assigns(:commission))
  end

  def test_should_destroy_commission
    assert_difference('Commission.count', -1) do
      delete :destroy, :id => commissions(:one).id
    end

    assert_redirected_to commissions_path
  end
end
