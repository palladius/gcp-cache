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
# This is me copying from stdout #allavecchia :)
DbSeedMagicSignature30dec22 = {
 :parse_asset_inventory_dict=>  ["ancestors", "asset_type", "name", "resource", "update_time"],
 :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
 :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
 :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
 :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
}

#ORG_FOLDER_PROJECTS_GRAPH_FOLDER
OrgFolderProjectsGraphFolder = ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_FOLDER', nil 

# This seeds random elements programmatically 
def seed_random_stuff()
    fake_projects = [] 

    Label.create(
        gcp_k: 'SeedVersion',
        gcp_val: SeedVersion,
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


def seed_from_org_folder_projects_graph(dir, opts={})
    opts_verbose = opts.fetch :verbose, true 
    #dir = ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_DIR', '' unless dir
    dir = File.expand_path dir
    puts "seed_from_org_folder_projects_graph(): Seeding from dir: #{dir}" if opts_verbose
    
    Dir["#{dir}/**/projects*.json"].each do |projects_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method( projects_json_file, '(ex obsolete func call) Proj json from OrgFolder stuff', ApplicationRecord, :haruspex_autoinfer )
    end
    # Magic Haruspec for Org
    Dir["#{dir}/**/org*.json"].each do |projects_json_file|
        puts "🗂️ + Found Org file: #{projects_json_file}" if opts_verbose
        x = ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method( projects_json_file, 'I presume its an Org.. #haruspex', ApplicationRecord, :haruspex_autoinfer )
        puts "Org end: #{x}"
        #exit 42
    end
    Dir["#{dir}/**/folder*.json"].each do |projects_json_file|
        #puts "+ Found Folder file: #{projects_json_file}" if opts_verbose
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method( projects_json_file, 'Folder json #haruspex', ApplicationRecord, :haruspex_autoinfer )
    end
   
end

def seed_from_bq_assets(dir=nil)
    Dir["db/fixtures/bq-exports/all-*.json"].each do |bq_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method(
            bq_json_file, 
            'BQ JSON exports for all', 
            InventoryItem, :parse_asset_inventory_dict)
        # puts "👀 File '#{bq_json_file}': #{json_buridone.count} items found" 
    end
end

def seed_from_gcloud_dumps
    Dir["db/fixtures/gcloud/project*.json"].each do |gcloud_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Project files from gcloud exports', 
            Folder, :parse_project_info)
    end
    Dir["db/fixtures/gcloud/organizations*.json"].each do |gcloud_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Org info from gcloud', 
            Folder, :parse_organization_info)
    end
    Dir["db/fixtures/gcloud/folders*.json"].each do |gcloud_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Folder info from gcloud', 
            Folder, :parse_folder_info)
    end 
    # These files are created from `populate-asset-inventory-from-gcloud.sh`
    Dir["db/fixtures/gcloud/inventory-per-project*.json"].each do |gcloud_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Inventory info from gcloud', 
            InventoryItem, :parse_asset_inventory_dict_from_gcloud)
    end
end


def main()
    t0 = Time.now
    puts "DB:SEED start at #{Time.now}."
    # TODO(ricc): query all assets :)
    puts "Riccardo, next step is to get TAGS. Try inspecting the latest projects in db/fixtures/gcloud/gcloud-projects-list-20221230-215526.json"
    # project creates stuff in the .cache directory
    seed_from_org_folder_projects_graph(OrgFolderProjectsGraphFolder + "/.cache/") unless OrgFolderProjectsGraphFolder.nil?
    seed_random_stuff
    seed_from_org_folder_projects_graph(ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_DIR')
    seed_from_bq_assets
    seed_from_gcloud_dumps
    puts "DB:SEED returned succesfully at #{Time.now}. Total time: #{Time.now - t0}sec. Miracle!"
    pp DbSeedMagicSignature #.inspect
end

main()