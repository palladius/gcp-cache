require "application_system_test_case"

class VmsTest < ApplicationSystemTestCase
  setup do
    @vm = vms(:one)
  end

  test "visiting the index" do
    visit vms_url
    assert_selector "h1", text: "Vms"
  end

  test "should create vm" do
    visit vms_url
    click_on "New vm"

    fill_in "Description", with: @vm.description
    fill_in "Disk1 name", with: @vm.disk1_name
    fill_in "Disk1 size gb", with: @vm.disk1_size_gb
    fill_in "External ip", with: @vm.external_ip
    fill_in "Internal ip", with: @vm.internal_ip
    fill_in "Internal notes", with: @vm.internal_notes
    check "Is preemptible" if @vm.is_preemptible
    fill_in "Machine type", with: @vm.machine_type
    fill_in "Name", with: @vm.name
    fill_in "Self link", with: @vm.self_link
    fill_in "Status", with: @vm.status
    fill_in "Zone", with: @vm.zone
    click_on "Create Vm"

    assert_text "Vm was successfully created"
    click_on "Back"
  end

  test "should update Vm" do
    visit vm_url(@vm)
    click_on "Edit this vm", match: :first

    fill_in "Description", with: @vm.description
    fill_in "Disk1 name", with: @vm.disk1_name
    fill_in "Disk1 size gb", with: @vm.disk1_size_gb
    fill_in "External ip", with: @vm.external_ip
    fill_in "Internal ip", with: @vm.internal_ip
    fill_in "Internal notes", with: @vm.internal_notes
    check "Is preemptible" if @vm.is_preemptible
    fill_in "Machine type", with: @vm.machine_type
    fill_in "Name", with: @vm.name
    fill_in "Self link", with: @vm.self_link
    fill_in "Status", with: @vm.status
    fill_in "Zone", with: @vm.zone
    click_on "Update Vm"

    assert_text "Vm was successfully updated"
    click_on "Back"
  end

  test "should destroy Vm" do
    visit vm_url(@vm)
    click_on "Destroy this vm", match: :first

    assert_text "Vm was successfully destroyed"
  end
end
