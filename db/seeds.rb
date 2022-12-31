# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#
SeedVersion = "1.5_221230"
# Max how many counts
MaxIndex = ENV.fetch('MAX_INDEX', '10' ).to_i
DbSeedMagicSignature = {}
DbSeedMagicSignature30dec22 = {
 :parse_asset_inventory_dict=>  ["ancestors", "asset_type", "name", "resource", "update_time"],
 :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
 :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
 :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
 :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
}
def seed_random_stuff()
    fake_projects = [] 

    Label.create(
        gcp_key: 'SeedVersion',
        gcp_value: SeedVersion,
    )

    (1..5).each do |ix|
        p = Project.create(
            project_id: "fake-riccardo-project-#{ix}",
            project_number: 12345678900 + ix,
            billing_account_id: '123456-7890AB-CDEF12',
            description: "Project # #{ix}.\nAdded by rake db:seed v#{SeedVersion}",
        )
        fake_projects << p
    end

    root_folder = Folder.create(
        name: 'my-fake-root-folder',
        folder_id: '1000',
        is_org: true, 
        #parent_id:string
        description: "This is my first root folder, also a dir. Added by rake db:seed v#{SeedVersion}",
    )
    root_folder2 = Folder.create(
        name: 'my-other-fake-org',
        folder_id: '2000',
        is_org: true, 
        #parent_id:string
        description: "This is my second root folder, also a dir. Added by rake db:seed v#{SeedVersion}",
    )
    [ root_folder, root_folder2].each do |my_root| 
        (1..3).each do |i| 
            child_n = Folder.create(
                name: "my-l1-child#{i}",
                folder_id: "0#{i}00",
                #is_org: false, 
                parent_id: my_root.id,
                description: "Child of #{my_root}. Added by rake db:seed v#{SeedVersion}",
            )
            if i ==2
                Folder.create(
                name: "my-l2-grandchild2-1",
                folder_id: "02#{i}0",
                #is_org: false, 
                parent_id: child_n.id,
                description: "7th son of a 7th son - with low budget. Added by rake db:seed v#{SeedVersion}",
            )
            end
            fake_projects[i].setParent(child_n)
        end
    end
end

# gets an array of projects 
# from gcloud XXX 
# def seed_projects_from_projects_file(json_file)
#     puts "OBSOLETE! Use the new my_method magic caller instead!"
#     f = File.read(json_file)
#     json_buridone = JSON.parse(f)
#     puts json_buridone.class
#     return unless  json_buridone.is_a? Array 

#     json_buridone.each do |ph|
#         puts "Parsing ProjectHash: #{ph}"
#         Folder.parse_project_info(ph, :json_file => json_file)
#     end
# end

def seed_from_org_folder_projects_graph(dir=nil)
    dir = ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_DIR', '' unless dir
    dir = File.expand_path dir
    #puts "Seeding from dir: #{dir}"
    Dir["#{dir}/**/projects*.json"].each do |projects_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            projects_json_file, 
            '(ex obsolete func call) Proj json from OrgFolder stuff', 
            Folder.method(:parse_project_info))
    end


end

def seed_from_bq_assets(dir=nil)
    Dir["db/fixtures/bq-exports/all-*.json"].each do |bq_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            bq_json_file, 
            'BQ JSON exports for all', 
            InventoryItem.method(:parse_asset_inventory_dict))
        # puts "👀 File '#{bq_json_file}': #{json_buridone.count} items found" 
    end
end

# https://stackoverflow.com/questions/30632724/how-to-pass-class-method-as-parameter
def generic_parse_array_of_jsons_from_file_with_method(json_file, description, my_method, opts={})
    # opts part
    puts "🔬 [DB🌱v#{SeedVersion}] Parsing #{description} file: #{json_file}"
    json_buridone = JSON.parse(File.read(json_file))
    if  json_buridone.is_a? Array 
        # we do have an array of a generic construct which the method can parse
        json_buridone.each_with_index do |single_json_construct, ix|
            #Folder.parse_organization_info(gcloud_org_dict) # rescue nil
            #puts "DEB sending to #{my_method} the construct: '''#{single_json_construct.inspect}'''"
            if single_json_construct.has_key?('labels')
                puts "File() with desc=#{description} has labels! #{single_json_construct['labels']}"
                exit 42
            end
            my_method.call(single_json_construct)
            if ix == 0 # only once
                puts "TODO(ricc): if you want to create a magic parse, note this:"
                puts "🖖 ArraySize: #{json_buridone.count}"
                puts "🖖 Method: #{my_method.name}"
                puts "🖖 DESC: #{description}"
                puts "🖖 json keys: #{single_json_construct.keys}"
                DbSeedMagicSignature[my_method.name.to_sym] = single_json_construct.keys
            end
            if ix >= MaxIndex
                puts "Returning from generic_parse_array_of_jsons_from_file_with_method (#{description}) after #{ix} calls, as i'm just testing and the file is HUMOUNGUSLY big (#{json_buridone.count})"
                return 0
            end
        end
    else
        puts "❌generic_parse_array_of_jsons_from_file_with_method: probably malformed json here: #{json_file}. Investigate and delete/regenerate."
        exit 49
    end
    return 0
end

def seed_from_gcloud_dumps
    Dir["db/fixtures/gcloud/project*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Project files from gcloud exports', 
            Folder.method(:parse_project_info))
    end
    Dir["db/fixtures/gcloud/organizations*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Org info from gcloud', 
            Folder.method(:parse_organization_info))
    end
    Dir["db/fixtures/gcloud/folders*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Folder info from gcloud', 
            Folder.method(:parse_folder_info))
    end 
    # These files are created from `populate-asset-inventory-from-gcloud.sh`
    Dir["db/fixtures/gcloud/inventory-per-project*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Inventory info from gcloud', 
            InventoryItem.method(:parse_asset_inventory_dict_from_gcloud))
    end
end



t0 = Time.now
puts "DB:SEED start at #{Time.now}."
# TODO(ricc): query all assets :)
puts "Riccardo, next step is to get TAGS. Try inspecting the latest projects in db/fixtures/gcloud/gcloud-projects-list-20221230-215526.json"
#exit 42
seed_random_stuff
seed_from_org_folder_projects_graph
seed_from_bq_assets
seed_from_gcloud_dumps
puts "DB:SEED returned succesfully at #{Time.now}. Total time: #{Time.now - t0}sec. Miracle!"
pp DbSeedMagicSignature #.inspect