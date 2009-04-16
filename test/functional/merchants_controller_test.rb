require 'test_helper'

class MerchantsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:merchants)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_merchant
    assert_difference('Merchant.count') do
      post :create, :merchant => { }
    end

    assert_redirected_to merchant_path(assigns(:merchant))
  end

  def test_should_show_merchant
    get :show, :id => merchants(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => merchants(:one).id
    assert_response :success
  end

  def test_should_update_merchant
    put :update, :id => merchants(:one).id, :merchant => { }
    assert_redirected_to merchant_path(assigns(:merchant))
  end

  def test_should_destroy_merchant
    assert_difference('Merchant.count', -1) do
      delete :destroy, :id => merchants(:one).id
    end

    assert_redirected_to merchants_path
  end
end
