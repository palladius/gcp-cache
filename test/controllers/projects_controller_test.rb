require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    assert_difference("Project.count") do
      post projects_url, params: { project: { billing_account_id: @project.billing_account_id, description: @project.description, lifecycle_state: @project.lifecycle_state, organization_id: @project.organization_id, parent_id: @project.parent_id, project_creation_time: @project.project_creation_time, project_id: @project.project_id, project_name: @project.project_name, project_number: @project.project_number } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { billing_account_id: @project.billing_account_id, description: @project.description, lifecycle_state: @project.lifecycle_state, organization_id: @project.organization_id, parent_id: @project.parent_id, project_creation_time: @project.project_creation_time, project_id: @project.project_id, project_name: @project.project_name, project_number: @project.project_number } }
    assert_redirected_to project_url(@project)
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
