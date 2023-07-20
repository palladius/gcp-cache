class InventoryItem < ApplicationRecord
  serialize :serialized_ancestors

  validates :name, uniqueness: { scope: [:asset_type] }
  #  validates_uniqueness_of :resource_discovery_name # not true this is the class! eg, "discoveryName" => "ProjectBillingInfo",

  has_many :labels, as: :labellable

  include AssetInventoryParser

  def ancestors
    begin
      serialized_ancestors
    rescue StandardError
      []
    end
  end

  def simplified_type
    #asset_type.split("/").last
    asset_type.gsub(".googleapis.com", "")
  end
  def simplified_name
    name.split("/").last
  end

  def organization_id
    begin
      ancestors.select { |x| x =~ /^organizations/ }[0].split("/").second
    rescue StandardError
      nil
    end
  end
  def organization
    Folder.find_by_folder_id(organization_id) # rescue nil
  end

  def to_s(verbose = true)
    if verbose
      "#{simplified_type} :#{INVENTORY_ITEM_ICON}: #{simplified_name}"
    else
      "#{simplified_name}"
    end
  end
  def self.class_emoji
    self.emoji
  end
  def self.emoji
    '🧺️'
  end

  def gcp_type
    :TODO
  end
end
