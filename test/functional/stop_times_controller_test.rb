require 'test_helper'

class StopTimesControllerTest < ActionController::TestCase
  setup do
    @stop_time = stop_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stop_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stop_time" do
    assert_difference('StopTime.count') do
      post :create, stop_time: @stop_time.attributes
    end

    assert_redirected_to stop_time_path(assigns(:stop_time))
  end

  test "should show stop_time" do
    get :show, id: @stop_time.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stop_time.to_param
    assert_response :success
  end

  test "should update stop_time" do
    put :update, id: @stop_time.to_param, stop_time: @stop_time.attributes
    assert_redirected_to stop_time_path(assigns(:stop_time))
  end

  test "should destroy stop_time" do
    assert_difference('StopTime.count', -1) do
      delete :destroy, id: @stop_time.to_param
    end

    assert_redirected_to stop_times_path
  end
end
