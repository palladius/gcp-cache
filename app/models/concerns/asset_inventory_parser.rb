# parses AI stuff

module AssetInventoryParser     
    extend ActiveSupport::Concern

    AssetInventoryParseVersion = '0.2a'

included do



=begin

This is how my object looks like:
{
"ancestors": [
  "projects/268290255727",
  "organizations/824879804362"
],
"asset_type": "compute.googleapis.com/Route",
"name": "//compute.googleapis.com/projects/metarepo/global/routes/default-route-012769675a080a1d",
# thiss seems to be always null
"resource": {
  "data": null,
  "discovery_document_uri": null,
  "discovery_name": null,
  "location": null,
  "parent": null,
  "resource_url": null,
  "version": null
},
"update_time": "2020-10-29 10:06:55"
}
=end  
  # from Folder but could come from everywhere, gence i put it here.
  # TODO move to concern -> parser :)
  def self.parse_asset_inventory_dict(aid, opts={}) # rescue nil    
    opts_verbose = opts.fetch :verbose, false

    if opts_verbose
      puts "💛Keys 🔑 v1: #{aid.keys}" # aid.keys
      puts "💛Ancestors: #{aid['ancestors']}"
      puts "💛AssetType: #{aid['asset_type']}"
      puts "💛Name: #{aid['name']}"
      puts "💛update_time: #{aid['update_time']}"
      non_nil_resources = aid['resource'].select{|k,v| not v.nil?}
      puts "💛💛💛💛NonNullResource: #{non_nil_resources}" unless non_nil_resources == {}
    end
    ii = InventoryItem.create(
      description: "💛 Created by AssetInventoryParser.parse_asset_inventory_dict v#{AssetInventoryParseVersion}",
      serialized_ancestors: aid['ancestors'],
      asset_type:  aid['asset_type'],
      name: aid['name'],
      gcp_update_time: aid['update_time'],     
      project: "TODO from AID.keys: #{aid.keys}",
      #TODO(riocc): add stuff which for now is always empty.. 
    )
    ii.add_labels_if_they_exist(aid)

    puts "👍 Created aii1💛 (##{ii.id}): #{ii}" if ii.valid?
  end

=begin

  Dont ask me why but gcloud returns SLIGHTLY different fields (!!)
  
  Keys here: 🔑 Keys: ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateT

{"assetType"=>"logging.googleapis.com/LogMetric",
 "createTime"=>"2020-09-14T09:28:43Z",
 "description"=>"errori che ho in k8s prod",
 "displayName"=>"errori-in-k8s-prod-distro",
 "location"=>"global",
 "name"=>
  "//logging.googleapis.com/projects/134140879415/metrics/errori-in-k8s-prod-distro",
 "parentAssetType"=>"cloudresourcemanager.googleapis.com/Project",
 "parentFullResourceName"=>
  "//cloudresourcemanager.googleapis.com/projects/ric-cccwiki",
 "project"=>"projects/134140879415",
 "updateTime"=>"2020-09-14T09:28:43Z"}

=end
  def self.parse_asset_inventory_dict_from_gcloud(aid, opts={}) # rescue nil
    opts_verbose = opts.fetch :verbose, false

    if opts_verbose
      puts "💙Keys 🔑 v2: #{aid.keys}"  
      puts "💙Ancestors: #{aid['ancestors']}"
      puts "💙AssetType: #{aid['assetType']}"
      puts "💙Name: #{aid['name']}"
      puts "💙displayName: #{aid['displayName']}"
      puts "💙update_time: #{aid['update_time']}"
    end
    improvised_ancestors = aid['ancestors'] ? 
      aid['ancestors'] :
      "carlessian/#{aid["parentAssetType"]}/carlessianTokenizer/#{aid["parentFullResourceName"]}"
    pp aid if opts_verbose

    megaDescription = "💙 Since it seems that this strange object has way more info than model can get, Imma gonna getta add it as an inspect :)
     Not last, for the reason that i have a very meaningful DESCRIPTION field Imma goona use :) 
     (parsed wwith AssetInventoryParser.parse_asset_inventory_dict_from_gcloud v#{AssetInventoryParseVersion}) 
     #{aid.inspect}" 
    ii = InventoryItem.create(
      serialized_ancestors: [
        "riccardo/was-here" , 
        improvised_ancestors,
        # of course I need to fix this, but useful to see how the serialization works the other way :)
      ],
      asset_type:  aid['assetType'],
      name: aid['name'],
      gcp_update_time: aid['updateTime'],     
      resource_location: aid['location'],
      created_at: aid['createTime'],
      resource_parent: aid['parentFullResourceName'],
      project: (aid['project'] rescue "TODO remove error #{$!}. Ais keys are: #{aid.keys}"),
      description: megaDescription, # there's too LITTLE in aid['description'],
    )
    ii.add_labels_if_they_exist(aid)
    puts "👍 Created aii2💙 (##{ii.id}): #{ii}" if ii.valid?
  end

end 

end