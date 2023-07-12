class Vm < ApplicationRecord
  include VmParser

  belongs_to :project

  #not really true: should be unique across name+zone+project
  validates :name, uniqueness: true, presence: true

  def short_zone
    zone.split("/").last
  end
  def short_machine_type
    machine_type.split("/").last
  end

  def self.icon
    "🚙''"
  end

  def ssh_command
    "gcloud --project #{self.project.project_id} compute ssh #{name} --zone #{short_zone}"
  end
end
