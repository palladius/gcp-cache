module AssetInventoryParser
  #module Gcp::AssetInventoryParser
  # parse_asset_inventory_dict_from_gcloud = %w[
  #   assetType
  #   createTime
  #   description
  #   displayName
  #   location
  #   name
  #   parentAssetType
  #   parentFullResourceName
  #   project
  #   updateTime
  # ]
  def parseAssetInventoryGcloudJsonIntoUInventoryItem(json_file, opts = {})
    env_max_index = ENV.fetch("MAX_INDEX", 100).to_i
    opts_max_elements = opts.fetch(:max_elements, env_max_index)
    opts_debug = opts.fetch :debug, false

    json_buridone = JSON.parse(File.read(json_file))
    raise "json_file content is NOT an array!" unless json_buridone.is_a? Array
    json_buridone.each_with_index do |hash, ix|
      puts(hash) if opts_debug
      if ix > opts_max_elements
        puts "Too many elements, I go out after #{opts_max_elements} just for testing :)"
        return
      end

      # { "ancestors" => ["projects/166652736589", "organizations/911748599584"],
      # "assetType" => "cloudbilling.googleapis.com/ProjectBillingInfo",
      # "name" => "//cloudbilling.googleapis.com/projects/vulcanina/billingInfo",
      # "resource" => { "data" => { "billingAccountName" => "billingAccounts/0014BA-601817-36A1AA",
      # "billingEnabled" => true,
      # "name" => "projects/vulcanina/billingInfo",
      # "projectId" => "vulcanina" },
      # "discoveryDocumentUri" => "https://cloudbilling.googleapis.com/$discovery/rest",
      # "discoveryName" => "ProjectBillingInfo",
      # "location" => "global",
      # "version" => "v1" },
      # "updateTime" => "2022-10-21T01:00:39.877641Z" }

      project = Project.find_or_create_by(project_id: hash["projectId"])

      ret =
        InventoryItem.create(
          serialized_ancestors: hash["ancestors"],
          name: hash["name"],
          asset_type: hash["assetType"],
          project: project,
          resource_discovery_name: hash["discoveryName"],
          gcp_update_time: hash["updateTime"],
          resource_location: hash['location'],
          description: "Created with jul23 aglorithm after it was broken for 7 months."
        )
      puts("Ret = #{ret}")
      #puts("Valid = #{ret.valid?}")
      unless ret.valid?
        puts("🤦🏻Ob ject.errors.messages  = #{ret.errors.messages}")
      end

      # do sth with it..
    end
  end
end

#puts "Ciao da Riccardo - file included"
