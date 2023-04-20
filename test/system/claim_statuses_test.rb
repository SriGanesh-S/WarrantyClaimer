require "application_system_test_case"

class ClaimStatusesTest < ApplicationSystemTestCase
  setup do
    @claim_status = claim_statuses(:one)
  end

  test "visiting the index" do
    visit claim_statuses_url
    assert_selector "h1", text: "Claim Statuses"
  end

  test "creating a Claim status" do
    visit claim_statuses_url
    click_on "New Claim Status"

    click_on "Create Claim status"

    assert_text "Claim status was successfully created"
    click_on "Back"
  end

  test "updating a Claim status" do
    visit claim_statuses_url
    click_on "Edit", match: :first

    click_on "Update Claim status"

    assert_text "Claim status was successfully updated"
    click_on "Back"
  end

  test "destroying a Claim status" do
    visit claim_statuses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Claim status was successfully destroyed"
  end
end
