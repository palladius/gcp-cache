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
        puts "existing_folder: #{existing_folder}"
#        f=Folder.new
        if existing_folder.is_a? Folder 
            # exists: then tweak
            f=existing_folder
        else
            f = Folder.create(
                folder_id: folder_id,
                is_org: is_org,
                description: "Folder created from Project JSON, so very poor in info: just folder id and type: #{parent_hash}.
                        Parent hash: #{parent_hash}\nAdded by seed_projects_from_projects_file as part rake db:seed v#{SeedVersion}",

            )
        end
        #)
        #f.save
        puts "Folder: #{f}"
        # "parent"=>{"id"=>
        # "885056483479", "type"=>"folder"}, 

        p = Project.create(
            project_id: ph['projectId'],
            project_number: ph['projectNumber'],
            project_name: ph['name'],
            lifecycle_state: ph['lifecycleState'],
            parent_id: f.id,
            organization_id: is_org ? f.folder_id : nil, # org id is the same :)
            #billing_account_id: '123456-7890AB-CDEF12',
            description: "Project found in file: #{json_file}.Parent hash: #{parent_hash}\nAdded by seed_projects_from_projects_file as part rake db:seed v#{SeedVersion}",
        )
        puts "Prject: #{p}"
        puts "---------------------------------------------------------------------------------"

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
    Dir["db/fixtures/bq-exports/*.json"].each do |bq_json_file|
        json_buridone = JSON.parse(File.read(bq_json_file))
        puts json_buridone.class
        next unless json_buridone.is_a? Array 
        # we do have an array
        json_buridone.each do |asset_inventoy_dict|
            Folder.parse_asset_inventoy_dict(asset_inventoy_dict) # rescue nil
        end
    end
    # f = File.read(json_file)
    # json_buridone = JSON.parse(f)
    # puts json_buridone.class
    # return unless  json_buridone.is_a? Array 
end

def seed_from_gcloud_dumps
    Dir["db/fixtures/gcloud/project*.json"].each do |bq_json_file|
        json_buridone = JSON.parse(File.read(bq_json_file))
        puts json_buridone.class
        next unless json_buridone.is_a? Array 
        # we do have an array
        json_buridone.each do |gcloud_project_dict|
            Folder.parse_project_info(gcloud_project_dict) # rescue nil
        end
    end
end





# TODO(ricc): restore the other two
# TODO(ricc): query all assets :)
#seed_random_stuff
#seed_from_org_folder_projects_graph
#seed_from_bq_assets
seed_from_gcloud_dumps