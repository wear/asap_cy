require 'test_helper'

class BookingsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:bookings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_booking
    assert_difference('Booking.count') do
      post :create, :booking => { }
    end

    assert_redirected_to booking_path(assigns(:booking))
  end

  def test_should_show_booking
    get :show, :id => bookings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => bookings(:one).id
    assert_response :success
  end

  def test_should_update_booking
    put :update, :id => bookings(:one).id, :booking => { }
    assert_redirected_to booking_path(assigns(:booking))
  end

  def test_should_destroy_booking
    assert_difference('Booking.count', -1) do
      delete :destroy, :id => bookings(:one).id
    end

    assert_redirected_to bookings_path
  end
end
