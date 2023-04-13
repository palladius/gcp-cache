
# normal one
# TODO(ricc) REMOVE> Only way for me to import this: :/
# NameError: uninitialized constant ActiveRecord::FixtureSet
#Rake.application["db:fixtures:load"].invoke
#Rake.application["db:fixtures"].invoke

#
SeedVersion = "1.6_230101"
# Max how many counts
MaxIndex = ENV.fetch('MAX_INDEX', '100' ).to_i
DbSeedMagicSignature = {}
# This is me copying from stdout #allavecchia :)
DbSeedMagicSignature30dec22 = {
 :parse_asset_inventory_dict=>  ["ancestors", "asset_type", "name", "resource", "update_time"],
 :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
 :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
 :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
 :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
}

#if ORG_FOLDER_PROJECTS_GRAPH_FOLDER is defined, i ONLY do that. Maybe some day i can change this, but as of now its a rare condition and i want to troubleshoot it easily./
OrgFolderProjectsGraphFolder = ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_FOLDER', nil
SeedFromLocalFixtures =  OrgFolderProjectsGraphFolder==nil # true
SeedFromLocalGclouds =  OrgFolderProjectsGraphFolder==nil # true
SeedFromBillingAccounts = true

# This seeds random elements programmatically
def seed_generic_stuff_programmatically()
    fake_projects = []

    #include FixtureFileHelpers

    fixtures_dir = "#{Rails.root}/db/fixtures/manhouse/"
    fixture_files = if ENV['FIXTURES']
            ENV['FIXTURES'].split(',')
        else
            # The use of String#[] here is to support namespaced fixtures
            Dir["#{fixtures_dir}/**/*.yml"].map {|f| f[(fixtures_dir.size + 1)..-5] }
        end

    # possibly gives error :)
    begin
        ret = ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, fixture_files) rescue "NOPE. Some error here."
        puts "OK fixtures: #{ret}"
    end

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
        p.add_labels({
            "type": "party-of-five",
            "pid#{ix}": "random-tagging-fake-riccardo-project-#{ix}",
        })
        fake_projects << p
    end

    root_folder = Folder.create(
        name: 'my-fake-root-folder',
        folder_id: '1000',
        is_org: true,
        #parent_id:string
        description: "This is my first root folder, also a dir. Added by rake db:seed v#{SeedVersion}",
        # serialized_labels: {
        #     "aaa": "bbb",
        #     "ccc": "ddd",
        # },
        # labelz:
    )
    root_folder.add_labels({
            "type": "hash",
            "fid": "one-thousand",
        })
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
            child_n.add_labels([['fid', "0#{i}00"]])
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
    end
    Dir["#{dir}/**/folder*.json"].each do |projects_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method( projects_json_file, 'Folder json #haruspex', ApplicationRecord, :haruspex_autoinfer )
    end

end

def seed_from_bq_assets(dir=nil)
    Dir["db/fixtures/bq-exports/all-*.json"].each do |bq_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method( bq_json_file, 'BQ JSON exports for all', InventoryItem, :parse_asset_inventory_dict)
        # puts "👀 File '#{bq_json_file}': #{json_buridone.count} items found"
    end
end

def seed_from_billing_accounts(dir=nil)
    Dir["db/fixtures/gcloud/baids.d/baids-for--*.json"].each do |baid_json_file|
        ApplicationRecord.generic_parse_array_of_jsons_from_file_with_method(
            baid_json_file, 'BAID JSON export from gcloud', BillingAccount, :parse_baid_dict)
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

    seed_generic_stuff_programmatically() if SeedFromLocalFixtures

    seed_from_billing_accounts() if SeedFromBillingAccounts
    #puts "Riccardo, next step is to get TAGS. Try inspecting the latest projects in db/fixtures/gcloud/gcloud-projects-list-20221230-215526.json"
    seed_from_org_folder_projects_graph(OrgFolderProjectsGraphFolder + "/.cache/") unless OrgFolderProjectsGraphFolder.nil?
    seed_from_org_folder_projects_graph(ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_DIR')
    seed_from_bq_assets() if SeedFromLocalGclouds
    seed_from_gcloud_dumps() if SeedFromLocalGclouds
    #pp DbSeedMagicSignature #.inspect
    File.write('.DbSeedMagicSignature.yaml', DbSeedMagicSignature.to_yaml)
    puts "File written: .DbSeedMagicSignature.yaml"
    puts "DB:SEED returned succesfully at #{Time.now}. Total time: #{Time.now - t0}sec. Miracle!"

end

main()
