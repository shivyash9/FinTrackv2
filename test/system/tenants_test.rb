require "application_system_test_case"

class TenantsTest < ApplicationSystemTestCase
  setup do
    @tenant = tenants(:one)
  end

  test "visiting the index" do
    visit tenants_url
    assert_selector "h1", text: "Tenants"
  end

  test "should create tenant" do
    visit tenants_url
    click_on "New tenant"

    fill_in "Database name", with: @tenant.database_name
    fill_in "Database password", with: @tenant.database_password
    fill_in "Database username", with: @tenant.database_username
    fill_in "Domain name", with: @tenant.domain_name
    fill_in "Name", with: @tenant.name
    fill_in "Plan", with: @tenant.plan
    check "Status" if @tenant.status
    click_on "Create Tenant"

    assert_text "Tenant was successfully created"
    click_on "Back"
  end

  test "should update Tenant" do
    visit tenant_url(@tenant)
    click_on "Edit this tenant", match: :first

    fill_in "Database name", with: @tenant.database_name
    fill_in "Database password", with: @tenant.database_password
    fill_in "Database username", with: @tenant.database_username
    fill_in "Domain name", with: @tenant.domain_name
    fill_in "Name", with: @tenant.name
    fill_in "Plan", with: @tenant.plan
    check "Status" if @tenant.status
    click_on "Update Tenant"

    assert_text "Tenant was successfully updated"
    click_on "Back"
  end

  test "should destroy Tenant" do
    visit tenant_url(@tenant)
    click_on "Destroy this tenant", match: :first

    assert_text "Tenant was successfully destroyed"
  end
end
