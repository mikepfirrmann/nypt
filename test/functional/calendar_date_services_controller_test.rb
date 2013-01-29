require 'test_helper'

class CalendarDateServicesControllerTest < ActionController::TestCase
  setup do
    @calendar_date_service = calendar_date_services(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calendar_date_services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create calendar_date_service" do
    assert_difference('CalendarDateService.count') do
      post :create, calendar_date_service: @calendar_date_service.attributes
    end

    assert_redirected_to calendar_date_service_path(assigns(:calendar_date_service))
  end

  test "should show calendar_date_service" do
    get :show, id: @calendar_date_service.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @calendar_date_service.to_param
    assert_response :success
  end

  test "should update calendar_date_service" do
    put :update, id: @calendar_date_service.to_param, calendar_date_service: @calendar_date_service.attributes
    assert_redirected_to calendar_date_service_path(assigns(:calendar_date_service))
  end

  test "should destroy calendar_date_service" do
    assert_difference('CalendarDateService.count', -1) do
      delete :destroy, id: @calendar_date_service.to_param
    end

    assert_redirected_to calendar_date_services_path
  end
end
