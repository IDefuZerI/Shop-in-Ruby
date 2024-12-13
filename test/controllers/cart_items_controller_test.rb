require "test_helper"

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get increment" do
    get cart_items_increment_url
    assert_response :success
  end

  test "should get decrement" do
    get cart_items_decrement_url
    assert_response :success
  end
end
