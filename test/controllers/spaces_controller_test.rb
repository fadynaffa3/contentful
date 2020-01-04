require 'test_helper'

class SpacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @space = spaces(:one)
  end

  test "should get index" do
    get spaces_url, as: :json
    assert_response :success
  end

  test "should create space" do
    assert_difference('Space.count') do
      post spaces_url, params: { space: { company_name: @space.company_name, description: @space.description } }, as: :json
    end

    assert_response 201
  end

  test "should show space" do
    get space_url(@space), as: :json
    assert_response :success
  end

  test "should update space" do
    patch space_url(@space), params: { space: { company_name: @space.company_name, description: @space.description } }, as: :json
    assert_response 200
  end

  test "should destroy space" do
    assert_difference('Space.count', -1) do
      delete space_url(@space), as: :json
    end

    assert_response 204
  end
end
