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

def seed_from_org_folder_projects_graph(dir, opts={})
    opts_verbose = opts.fetch :verbose, true 
    #dir = ENV.fetch 'ORG_FOLDER_PROJECTS_GRAPH_DIR', '' unless dir
    dir = File.expand_path dir
    puts "seed_from_org_folder_projects_graph(): Seeding from dir: #{dir}" if opts_verbose
    # Dir["#{dir}/**/projects*.json"].each do |projects_json_file|
    #     puts "+ Found file: #{projects_json_file}" if opts_verbose
    #     generic_parse_array_of_jsons_from_file_with_method(
    #         projects_json_file, 
    #         '(ex obsolete func call) Proj json from OrgFolder stuff', 
    #         Folder, 
    #         :parse_project_info,
    #         )
    # end
    Dir["#{dir}/**/projects*.json"].each do |projects_json_file|
        #puts "+ Found file: #{projects_json_file}" if opts_verbose
        generic_parse_array_of_jsons_from_file_with_method( projects_json_file, '(ex obsolete func call) Proj json from OrgFolder stuff', ApplicationRecord, :haruspex_autoinfer )
    end
    # Magic Haruspec for Org
    Dir["#{dir}/**/org*.json"].each do |projects_json_file|
        puts "🗂️ + Found Org file: #{projects_json_file}" if opts_verbose
        generic_parse_array_of_jsons_from_file_with_method( projects_json_file, 'I presume its an Org.. #haruspex', ApplicationRecord, :haruspex_autoinfer )
        puts "Org end"
        exit 42
    end
    Dir["#{dir}/**/folder*.json"].each do |projects_json_file|
        #puts "+ Found Folder file: #{projects_json_file}" if opts_verbose
        generic_parse_array_of_jsons_from_file_with_method( projects_json_file, 'Folder json #haruspex', ApplicationRecord, :haruspex_autoinfer )
    end
   
end

def seed_from_bq_assets(dir=nil)
    Dir["db/fixtures/bq-exports/all-*.json"].each do |bq_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            bq_json_file, 
            'BQ JSON exports for all', 
            InventoryItem, :parse_asset_inventory_dict)
        # puts "👀 File '#{bq_json_file}': #{json_buridone.count} items found" 
    end
end

# https://stackoverflow.com/questions/30632724/how-to-pass-class-method-as-parameter
def generic_parse_array_of_jsons_from_file_with_method(json_file, description, my_class, method_name, opts={})
    # opts part
    opts_verbose = opts.fetch :verbose, true

    my_method=my_class.method(method_name) # Folder, :blah -> #<Method: Folder (call 'Folder.connection' to establish a connection).parse_folder_info(hash, opts=...) ./app/models/concerns/gcp_stuff_parser.rb:148>
    puts "🔬 [DB🌱v#{SeedVersion}] Parsing #{description} file: #{json_file}"
    json_buridone = JSON.parse(File.read(json_file))
    if  json_buridone.is_a? Array 
        if json_buridone.size == 0
            puts "Empty Array - skipping. Or maybe delete this file: #{json_file}"
            return 0
        end
        # I need to check ONLY once and substitute with right thingy
        if method_name == :haruspex_autoinfer
            puts 'generic_parse_array_of_jsons_from_file_with_method TODO' 
            ret = my_class.haruspex_autoinfer(json_buridone[0])
            puts "ret = #{ret}"
            my_class = ret[0]
            method_name = ret[1]
            puts "💣 Nuclear Launch [AUTO]detected! Harsupex seems to have work. Calling now: #{my_class}::#{method_name} for an array of #{json_buridone.size} elements!"
            #exit 42
        end
        # we do have an array of a generic construct which the method can parse
        json_buridone.each_with_index do |single_json_construct, ix|
            #Folder.parse_organization_info(gcloud_org_dict) # rescue nil
            #puts "DEB sending to #{my_method} the construct: '''#{single_json_construct.inspect}'''"
            if single_json_construct.has_key?('labels')
                puts "JSON construct ##{ix} from File('#{json_file}',desc=#{description}) DOES HAVE labels: #{single_json_construct['labels']}"
            end
            my_method.call(single_json_construct)
            if ix == 0 # only once
                puts "🖖 ArraySize: #{json_buridone.count}" if opts_verbose
                puts "🖖 Method: #{my_method.name}" if opts_verbose
                puts "🖖 DESC: #{description}" if opts_verbose
                puts "🖖 #{my_class.emoji} JSON 🗝 keys[#{my_method.name}] : #{single_json_construct.keys}"
                #haruspexHashKeysFromTeaLeaves(single_json_construct, my_class, my_method, description, opts}
                DbSeedMagicSignature[my_method.name.to_sym] = single_json_construct.keys
            end
            if ix >= MaxIndex
                puts "Returning from generic_parse_array_of_jsons_from_file_with_method (#{description}) after #{ix} calls, as i'm just testing and the file is HUMOUNGUSLY big (#{json_buridone.count})"
                return 0
            end
        end
    elsif json_buridone.is_a?(Hash)
        puts "TODO(ricc): get common code into another function and call it from here with ix=0"
        function_yet_to_be_written(json_buridone, 0)
    else
        puts "❌generic_parse_array_of_jsons_from_file_with_method: probably malformed json here: #{json_file}. Investigate and delete/regenerate. json_buridone.class = #{json_buridone.class}"
        exit 49
    end
    return 0
end

def seed_from_gcloud_dumps
    Dir["db/fixtures/gcloud/project*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Project files from gcloud exports', 
            Folder, :parse_project_info)
    end
    Dir["db/fixtures/gcloud/organizations*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Org info from gcloud', 
            Folder, :parse_organization_info)
    end
    Dir["db/fixtures/gcloud/folders*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
            gcloud_json_file, 
            'Folder info from gcloud', 
            Folder, :parse_folder_info)
    end 
    # These files are created from `populate-asset-inventory-from-gcloud.sh`
    Dir["db/fixtures/gcloud/inventory-per-project*.json"].each do |gcloud_json_file|
        generic_parse_array_of_jsons_from_file_with_method(
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
    puts :END42
    exit 42
    seed_from_bq_assets
    seed_from_gcloud_dumps
    puts "DB:SEED returned succesfully at #{Time.now}. Total time: #{Time.now - t0}sec. Miracle!"
    pp DbSeedMagicSignature #.inspect
end

main()