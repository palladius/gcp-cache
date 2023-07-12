require "test_helper"

class VmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vm = vms(:one)
  end

  test "should get index" do
    get vms_url
    assert_response :success
  end

  test "should get new" do
    get new_vm_url
    assert_response :success
  end

  test "should create vm" do
    assert_difference("Vm.count") do
      post vms_url, params: { vm: { description: @vm.description, disk1_name: @vm.disk1_name, disk1_size_gb: @vm.disk1_size_gb, external_ip: @vm.external_ip, internal_ip: @vm.internal_ip, internal_notes: @vm.internal_notes, is_preemptible: @vm.is_preemptible, machine_type: @vm.machine_type, name: @vm.name, project_id: @vm.project_id, self_link: @vm.self_link, status: @vm.status, zone: @vm.zone } }
    end

    assert_redirected_to vm_url(Vm.last)
  end

  test "should show vm" do
    get vm_url(@vm)
    assert_response :success
  end

  test "should get edit" do
    get edit_vm_url(@vm)
    assert_response :success
  end

  test "should update vm" do
    patch vm_url(@vm), params: { vm: { description: @vm.description, disk1_name: @vm.disk1_name, disk1_size_gb: @vm.disk1_size_gb, external_ip: @vm.external_ip, internal_ip: @vm.internal_ip, internal_notes: @vm.internal_notes, is_preemptible: @vm.is_preemptible, machine_type: @vm.machine_type, name: @vm.name, project_id: @vm.project_id, self_link: @vm.self_link, status: @vm.status, zone: @vm.zone } }
    assert_redirected_to vm_url(@vm)
  end

  test "should destroy vm" do
    assert_difference("Vm.count", -1) do
      delete vm_url(@vm)
    end

    assert_redirected_to vms_url
  end
end
