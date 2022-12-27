require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "should create project" do
    visit projects_url
    click_on "New project"

    fill_in "Billing account", with: @project.billing_account_id
    fill_in "Description", with: @project.description
    fill_in "Lifecycle state", with: @project.lifecycle_state
    fill_in "Organization", with: @project.organization_id
    fill_in "Parent", with: @project.parent_id
    fill_in "Project creation time", with: @project.project_creation_time
    fill_in "Project", with: @project.project_id
    fill_in "Project name", with: @project.project_name
    fill_in "Project number", with: @project.project_number
    click_on "Create Project"

    assert_text "Project was successfully created"
    click_on "Back"
  end

  test "should update Project" do
    visit project_url(@project)
    click_on "Edit this project", match: :first

    fill_in "Billing account", with: @project.billing_account_id
    fill_in "Description", with: @project.description
    fill_in "Lifecycle state", with: @project.lifecycle_state
    fill_in "Organization", with: @project.organization_id
    fill_in "Parent", with: @project.parent_id
    fill_in "Project creation time", with: @project.project_creation_time
    fill_in "Project", with: @project.project_id
    fill_in "Project name", with: @project.project_name
    fill_in "Project number", with: @project.project_number
    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end

  test "should destroy Project" do
    visit project_url(@project)
    click_on "Destroy this project", match: :first

    assert_text "Project was successfully destroyed"
  end
end
