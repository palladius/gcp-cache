module GcpStuffParser     
    extend ActiveSupport::Concern

    puts "Including GcpStuffParser module REMOVEME when it works"

    # included do
    #   default_scope   where(trashed: false)
    #   scope :trashed, where(trashed: true)
    # end

    # def trash
    #   update_attribute :trashed, true
    # end


    ParseVersion = '1.0'

included do

  def self.find_magically_by_fqdn(my_fqdn)
    polymorphic_type, polymorphic_id = my_fqdn.split('/')
    case polymorphic_type
    when 'projects'
      Project.find_by_project_number(polymorphic_id)
    when 'folders', 'organizations'
      #Folder.where(folder_id: polymorphic_id, folder_type: polymorphic_type)
      Folder.find_by_folder_id(polymorphic_id) # , folder_type: polymorphic_type)
    when 'riccardo', 'carlessian'
      'TODO(ricc): implement the II v2'
    else 
      raise "Unknown 🐸 Frog type: '#{polymorphic_type}'. I only know Projects, Folders and Orgs (aka Frogs)"
    end
  end


=begin  
Smaple project:
{"createTime"=>"2021-12-03T07:43:33.346Z",
 "lifecycleState"=>"ACTIVE",
 "name"=>"da-cicd-tests",
 "parent"=>{"id"=>"824879804362", "type"=>"organization"},
 "projectId"=>"da-cicd-tests",
 "projectNumber"=>"882043492617"}
=end
  def self.parse_project_info(ph, opts={})
    opts_json_file = opts.fetch :json_file, nil
    opts_verbose = opts.fetch :verbose, false
    #pp ph

    parent_folder_or_org = 'todo'
    # t.string "organization_id"
    # t.string "parent_id"

    ########################################
    # part 1. Create the parent (folder or org)
    parent_hash = ph['parent']
    folder_id = ph['parent']['id']
    folder_type = ph['parent']['type']
    is_org = folder_type == 'organization'
    existing_folder = Folder.find_by( folder_id: folder_id,)
    #puts "existing_folder: #{existing_folder}"
#        f=Folder.new
    if existing_folder.is_a? Folder 
        puts "Folder exists! #{existing_folder}" if opts_verbose
        f=existing_folder
    else
        puts "Folder DOESNT exist, creating it: #{existing_folder}"
        f = Folder.create(
            folder_id: folder_id,
            is_org: is_org,
            description: "Folder created from Project JSON, so very poor in info: just folder id and type: #{parent_hash}.
                    Parent hash: #{parent_hash}\nAdded by seed_projects_from_projects_file as part rake db:seed v#{SeedVersion}",

        )
    end
    puts "Folder: #{f}" if opts_verbose

    existing_project = Project.find_by_project_id(ph['projectId'])
    if existing_project 
      puts "Project exists! Skipping: #{existing_project.to_s}"  if opts_verbose
      p = existing_project
    else
      p = Project.create(
          project_id: ph['projectId'],
          project_number: ph['projectNumber'],
          project_name: ph['name'],
          lifecycle_state: ph['lifecycleState'],
          parent_id: f.id,
          organization_id: is_org ? f.folder_id : nil, # org id is the same :)
          #billing_account_id: '123456-7890AB-CDEF12',
          description: "Project found in file: #{opts_json_file}.Parent hash: #{parent_hash}\nAdded by seed_projects_from_projects_file as part rake db:seed v#{SeedVersion}",
      )
    end
    puts "👍 Project just created: #{p}"
  end


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
  def self.parse_asset_inventory_dict(aid) # rescue nil
    #puts "+++ Folder.parse_asset_inventoy_dict(asset_inventoy_dict)"
    #puts "parse_asset_inventory_dict: 📝TODO📝 I might want to manage this once I have a vision of ALL asset inventotry objects and maybe can put them al in a similar place."
    
    puts "🔑 Keys v1: #{aid.keys}" # aid.keys
    puts "💛Ancestors: #{aid['ancestors']}"
    puts "💛AssetType: #{aid['asset_type']}"
    puts "💛Name: #{aid['name']}"
    puts "💛update_time: #{aid['update_time']}"
    non_nil_resources = aid['resource'].select{|k,v| not v.nil?}
    puts "💛💛💛💛NonNullResource: #{non_nil_resources}" unless non_nil_resources == {}
    #pp aid
    ii = InventoryItem.create(
      description: "Created by parse_asset_inventoy_dict v#{ParseVersion}",
      serialized_ancestors: aid['ancestors'],
      asset_type:  aid['asset_type'],
      name: aid['name'],
      gcp_update_time: aid['update_time'],     
      #TODO(riocc): add stuff which for now is always empty.. 
    )
    puts "👍 Created ii: #{ii}"
    puts "^" * 80
    
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

    #puts "+++ slightly different Folder.parse_asset_inventoy_dict(asset_inventoy_dict)"
    puts "🔑 Keys v2 💙: #{aid.keys}"  if opts_verbose
    puts "💙Ancestors: #{aid['ancestors']}" if opts_verbose
    puts "💙AssetType: #{aid['assetType']}" if opts_verbose
    puts "💙Name: #{aid['name']}" if opts_verbose
    puts "💙displayName: #{aid['displayName']}" if opts_verbose
    puts "💙update_time: #{aid['update_time']}" if opts_verbose
    improvised_ancestors = aid['ancestors'] ? 
      aid['ancestors'] :
      "carlessian/#{aid["parentAssetType"]}/carlessianTokenizer/#{aid["parentFullResourceName"]}"
    pp aid if opts_verbose
    megaDescription = "Since it seems that this strange object has way more info than model can get, Imma gonna getta add it as an inspect :) Not last, for the reason that i have a very meaningful DESCIRPTION field Imma goona use :) #{aid.inspect}" 
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
      description: megaDescription, # there's too LITTLE in aid['description'],
    )
    puts "👍 Created ii2: #{ii}"   
  end

=begin
  This is how an Org JSOn looks like:
  {
    "creationTime": "2020-12-16T06:27:16.484Z",
    "displayName": "palladius.eu",
    "lifecycleState": "ACTIVE",
    "name": "organizations/803957416449",
    "owner": {
      "directoryCustomerId": "C03dncc8m"
    }
  },
=end
  def self.parse_organization_info(hash, opts={})
    opts_verbose = opts.fetch :verbose, false

    #pp hash['name'] # "organizations/44433984155"
    org_id = hash['name'].split('/').second
    existing_org = Folder.find_by_folder_id(org_id)
    if existing_org
      puts "🎯 Org already exists! #{existing_org}" if opts_verbose # cache hit emoji
      o = existing_org
    else
      o = Folder.create(
        name: hash['displayName'],
        is_org: true,
        folder_id: org_id,
        domain: hash['displayName'], # I assume its a domain..
        description: "Created from parse_organization_info",
        gcp_creation_time: hash['creationTime'],
        lifecycle_state: hash['lifecycleState'],
        directory_customer_id: hash['owner']['directoryCustomerId'],
      )
      puts "👍 Org just created: #{o}"
    end
    puts "Folder Org is: #{o.inspect}" if opts_verbose
  end

=begin
example:
{"createTime"=>"2022-09-19T13:34:39.089Z",
 "displayName"=>"Pulumi",
 "lifecycleState"=>"ACTIVE",
 "name"=>"folders/1054494897637",
 "parent"=>"organizations/4879804362  "}
=end

  def self.parse_folder_info(hash, opts={})
    opts_create_parent_if_missing = opts.fetch :create_parent_if_missing, true

    folder_type = hash['name'].split('/').first # should be 'folders' or 'organizations' 
    folder_id = hash['name'].split('/').second

    parent_folder_type, parent_folder_id = hash['parent'].split('/') # this aint python.
    parent = hash['name'] # could be an Org or a Folder, eg "organizations/824879804362"
    puts folder_id
    existing_folder = Folder.find_by(frog_type: folder_type, folder_id: folder_id)
    #puts "Exists? #{existing_folder}"
    if existing_folder
        puts "Existing! #{existing_folder}."
        f = existing_folder
    else
      #puts "Doesnt exist -> creating"
      f = Folder.create(
        frog_type: folder_type,
        folder_id: folder_id,
        description: "Created with parse_folder_info from a hash",
        name: hash['displayName'],
        parent_id: parent_folder_id,
        gcp_creation_time: hash['createTime'],
        lifecycle_state: hash['lifecycleState'],
        )
      puts "👍 New folder created: #{f}"
    end

    if opts_create_parent_if_missing
      existing_parent =  Folder.find_by_fqdn(hash['parent'])
      if existing_parent
        puts "🎯 Parent Folder/Org (🐸) exists! #{existing_parent}"
      else
        f_parent = Folder.create(
          frog_type: hash['parent'].split('/').first,
          folder_id: hash['parent'].split('/').second,
          description: "Created as parent of a folder so very little info available",
        )
        puts "👍 Frog Parent created (yet lacunary): #{f_parent}"
      end
    end
  end

end # /included

class_methods do

end #/class_methods

end
