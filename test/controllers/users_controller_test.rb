require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  fixtures :none  # Don't load any fixtures for this test

  setup do
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
  end
end
