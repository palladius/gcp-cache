class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class


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
          billing_account_id: '123456-7890AB-CDEF12',
          description: "Project found in file: #{opts_json_file}.Parent hash: #{parent_hash}\nAdded by seed_projects_from_projects_file as part rake db:seed v#{SeedVersion}",
      )
    end
    puts "👍 Project just created: #{p}"
  end

  # from Folder but could come from everywhere, gence i put it here.
  # TODO move to concern -> parser :)
  def self.parse_asset_inventoy_dict(aid) # rescue nil
    #puts "+++ Folder.parse_asset_inventoy_dict(asset_inventoy_dict)"
    puts "parse_asset_inventoy_dict: 📝TODO📝 I might want to manage this once I have a vision of ALL asset inventotry objects and maybe can put them al in a similar place."
    return 
    #puts aid.keys
    puts "💛Ancestors💛: #{aid['ancestors']}"
    puts "💛AssetType💛: #{aid['asset_type']}"
    puts "💛Name💛: #{aid['name']}"
    puts "💛update_time💛: #{aid['update_time']}"
    #puts "NonNullResources: #{aid['resources']}"
    #pp aid
    
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
    #puts :TODO_ORG_⛏️
    #pp hash['name'] # "organizations/44433984155"
    org_id = hash['name'].split('/').second
    existing_org = Folder.find_by_folder_id(org_id)
    if existing_org
      puts "🎯 Org already exists! #{existing_org}" # cache hit emoji
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
    puts "Folder Org is: #{o.inspect}"
  end

  def self.parse_folder_info(hash, opts={})
    puts :TODO_FOLDER_⛏️
    pp hash
  end
end
