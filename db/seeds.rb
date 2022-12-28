# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

SeedVersion = "1.3_221228"

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
        name: 'my-root',
        folder_id: '1000',
        is_org: true, 
        #parent_id:string
        description: "This is my first root folder, also a dir. Added by rake db:seed v#{SeedVersion}",
    )
    root_folder2 = Folder.create(
        name: 'my-other-org',
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
def seed_projects_from_projects_file(json_file)
    f = File.read(json_file)
    json_buridone = JSON.parse(f)
    puts json_buridone.class
    return unless  json_buridone.is_a? Array 

    json_buridone.each do |ph|
        puts "Parsing ProjectHash: #{ph}"
        Folder.parse_project_info(ph, :json_file => json_file)
    end

    
end

def seed_from_org_folder_projects_graph(dir=nil)
    dir = ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_DIR', '' unless dir
    dir = File.expand_path dir
    puts "Seeding from dir: #{dir}"
    #puts Dir["#{dir}/**/*.json"]
    Dir["#{dir}/**/projects*.json"].each do |projects_json_file|
        seed_projects_from_projects_file(projects_json_file)
    end


end

def seed_from_bq_assets(dir=nil)
    #dir ||= 'db/fixtures/bq-exports/'
    Dir["db/fixtures/bq-exports/all-*.json"].each do |bq_json_file|
        json_buridone = JSON.parse(File.read(bq_json_file))
        puts json_buridone.class
        next unless json_buridone.is_a? Array 
        # we do have an array
        puts "👀 File '#{bq_json_file}': #{json_buridone.count} items found"
        json_buridone.each_with_index do |asset_inventoy_dict, ix|
            Folder.parse_asset_inventory_dict(asset_inventoy_dict) # rescue nil
            if ix >= 2
                puts "Returning as i'm just testing and the file is HUMOUNGUSLY big"
                return 

            end
        end
    end
    # f = File.read(json_file)
    # json_buridone = JSON.parse(f)
    # puts json_buridone.class
    # return unless  json_buridone.is_a? Array 
end

def seed_from_gcloud_dumps
    Dir["db/fixtures/gcloud/project*.json"].each do |gcloud_json_file|
        puts "🔬 Parsing Project file #{gcloud_json_file}"
        json_buridone = JSON.parse(File.read(gcloud_json_file))
        next unless json_buridone.is_a? Array 
        # we do have an array
        json_buridone.each do |gcloud_project_dict|
            Folder.parse_project_info(gcloud_project_dict) # rescue nil
        end
    end if false
    Dir["db/fixtures/gcloud/organizations*.json"].each do |gcloud_json_file|
        puts "🔬 Parsing Org file #{gcloud_json_file}"
        json_buridone = JSON.parse(File.read(gcloud_json_file))
        next unless json_buridone.is_a? Array 
        # we do have an array
        json_buridone.each do |gcloud_org_dict|
            Folder.parse_organization_info(gcloud_org_dict) # rescue nil
        end
    end if false
    Dir["db/fixtures/gcloud/folders*.json"].each do |gcloud_json_file|
        puts "🔬 Parsing Folder file #{gcloud_json_file}"
        json_buridone = JSON.parse(File.read(gcloud_json_file))
        next unless json_buridone.is_a? Array 
        json_buridone.each do |gcloud_folder_dict|
            Folder.parse_folder_info(gcloud_folder_dict) # rescue nil
        end
    end if false
    # These files are created from `populate-asset-inventory-from-gcloud.sh`
    Dir["db/fixtures/gcloud/inventory-per-project*.json"].each do |gcloud_json_file|
        puts "🔬 Parsing Inventory from single project from file #{gcloud_json_file}"
        json_buridone = JSON.parse(File.read(gcloud_json_file)) rescue "Error: #{$!}" 
        next unless json_buridone.is_a? Array 
        json_buridone.each do |gcloud_inventory_stuff_dict|
            Folder.parse_asset_inventory_dict_from_gcloud(gcloud_inventory_stuff_dict) # seriously, Google? :(
            #exit 42
            #sleep(2)
            # todo remove me
        end
    end
end



puts :main
# TODO(ricc): restore the other two
# TODO(ricc): query all assets :)
seed_random_stuff
seed_from_org_folder_projects_graph
seed_from_bq_assets
seed_from_gcloud_dumps