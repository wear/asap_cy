require 'test_helper'

class DiscountsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:discounts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_discount
    assert_difference('Discount.count') do
      post :create, :discount => { }
    end

    assert_redirected_to discount_path(assigns(:discount))
  end

  def test_should_show_discount
    get :show, :id => discounts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => discounts(:one).id
    assert_response :success
  end

  def test_should_update_discount
    put :update, :id => discounts(:one).id, :discount => { }
    assert_redirected_to discount_path(assigns(:discount))
  end

  def test_should_destroy_discount
    assert_difference('Discount.count', -1) do
      delete :destroy, :id => discounts(:one).id
    end

    assert_redirected_to discounts_path
  end
end
