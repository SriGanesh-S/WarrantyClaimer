require "test_helper"

class ClaimStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @claim_status = claim_statuses(:one)
  end

  test "should get index" do
    get claim_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_claim_status_url
    assert_response :success
  end

  test "should create claim_status" do
    assert_difference('ClaimStatus.count') do
      post claim_statuses_url, params: { claim_status: {  } }
    end

    assert_redirected_to claim_status_url(ClaimStatus.last)
  end

  test "should show claim_status" do
    get claim_status_url(@claim_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_claim_status_url(@claim_status)
    assert_response :success
  end

  test "should update claim_status" do
    patch claim_status_url(@claim_status), params: { claim_status: {  } }
    assert_redirected_to claim_status_url(@claim_status)
  end

  test "should destroy claim_status" do
    assert_difference('ClaimStatus.count', -1) do
      delete claim_status_url(@claim_status)
    end

    assert_redirected_to claim_statuses_url
  end
end
