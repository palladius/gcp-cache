require "application_system_test_case"

class BillingAccountsTest < ApplicationSystemTestCase
  setup do
    @billing_account = billing_accounts(:one)
  end

  test "visiting the index" do
    visit billing_accounts_url
    assert_selector "h1", text: "Billing accounts"
  end

  test "should create billing account" do
    visit billing_accounts_url
    click_on "New billing account"

    fill_in "Baid", with: @billing_account.baid
    fill_in "Description", with: @billing_account.description
    fill_in "Display name", with: @billing_account.display_name
    fill_in "Master billing account", with: @billing_account.master_billing_account
    fill_in "Name", with: @billing_account.name
    check "Open" if @billing_account.open
    click_on "Create Billing account"

    assert_text "Billing account was successfully created"
    click_on "Back"
  end

  test "should update Billing account" do
    visit billing_account_url(@billing_account)
    click_on "Edit this billing account", match: :first

    fill_in "Baid", with: @billing_account.baid
    fill_in "Description", with: @billing_account.description
    fill_in "Display name", with: @billing_account.display_name
    fill_in "Master billing account", with: @billing_account.master_billing_account
    fill_in "Name", with: @billing_account.name
    check "Open" if @billing_account.open
    click_on "Update Billing account"

    assert_text "Billing account was successfully updated"
    click_on "Back"
  end

  test "should destroy Billing account" do
    visit billing_account_url(@billing_account)
    click_on "Destroy this billing account", match: :first

    assert_text "Billing account was successfully destroyed"
  end
end
