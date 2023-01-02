# automatically parses with right function based on keys of hash being parsed.
module HaruspexMagicParser     
    extend ActiveSupport::Concern

    HaruspexMagicParserVersion ||= '0.0.2'

    DbSeedMagicSignature30dec22 = {
        :parse_asset_inventory_dict=>  ["ancestors", "asset_type", "name", "resource", "update_time"],
        :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
        :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
        :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
        :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
    }
    # DbSeedMagicSignature30dec22 = {
    #     :parse_asset_inventory_dict =>  ["ancestors", "asset_type", "name", "resource", "update_time"],
    #     :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
    #     :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
    #     :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
    #     :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
    # }
    #asset_inventory_parser.rb:

included do

    # This is the summa of Riccardo ability to write good, unreadable code :) 
    # We're autoinferring what function to call based on the hash keys shape.
    # This would be much easier if the keys stayed the same :)
    # Should return a copule Class and Method :) 
    def self.haruspex_autoinfer(hash, opts={})
        opts_verbose = opts.fetch :verbose, false
        raise "haruspex_autoinfer(): Expecting a hash, got a #{hash.class}" unless hash.class == Hash

        # labels: appears saltuarily on any thing.
        # additionalAttributes: Found in some InventoryItems - super interesting as its a VERY generic keyval. Super yummie.
        # Should capture some day in the future.
        hash=hash.except('labels', 'additionalAttributes')
        
        my_keys = hash.keys
        # find best match for this hash..
        puts my_keys.join(', ') if opts_verbose
        matching_methods = {}
        DbSeedMagicSignature30dec22.each do |k,v| 
            matching_methods[k] = {}
            # https://stackoverflow.com/questions/7387937/how-to-determine-if-one-array-contains-all-elements-of-another-array
            matching_methods[k][:all] = my_keys.all? { |e| v.include?(e) }
            matching_methods[k][:reverse_all] = v.all? { |e| my_keys.include?(e) }
            matching_methods[k][:method_size] = v.size
            matching_methods[k][:buridone_size] = my_keys.size

            if( matching_methods[k][:all])
                puts "🐦 haruspex_autoinfer(): Found match! #{matching_methods[k]}" if opts_verbose
                # for now i dont want to also jknow the model, I'll just keep it simple.
                return [ApplicationRecord, k]
            end
        end
        pp(matching_methods) if opts_verbose
        puts "I failed miserably to autoinfer this couple of keys: Sorry! #{my_keys}" 
        raise "🐦 haruspex_autoinfer(): Unknown key-pair-ad-bal: #{my_keys}"
    end


    def self.private_parse_single_json(json_file, single_json_construct, description, my_class, method_name, ix, opts)
        opts_verbose = opts.fetch :verbose, false

        # I need to check ONLY once and substitute with right thingy
        my_method=my_class.method(method_name)

        if single_json_construct.has_key?('labels')
            puts "JSON construct ##{ix} from File('#{json_file}',desc=#{description}) DOES HAVE labels: #{single_json_construct['labels']}" if opts_verbose
        end
        ret = my_method.call(single_json_construct)
        #puts "TODO bring out: ret=#{ret}"
        if ix == 0 # only once
            #puts "🖖 ArraySize: #{json_buridone.count}" if opts_verbose
            puts "🖖 Method: #{my_method.name}" if opts_verbose
            puts "🖖 DESC: #{description}" if opts_verbose
            puts "🖖 #{my_class.emoji} JSON 🗝 keys[#{my_method.name}] : #{single_json_construct.keys}"
            #haruspexHashKeysFromTeaLeaves(single_json_construct, my_class, my_method, description, opts}
            DbSeedMagicSignature[my_method.name.to_sym] = single_json_construct.keys
        end
        return ["mymethod=#{my_method}", ret]
    end

        # https://stackoverflow.com/questions/30632724/how-to-pass-class-method-as-parameter
        # returns the LAST element parsed, hopefully :)
        def self.generic_parse_array_of_jsons_from_file_with_method(json_file, description, my_class, method_name, opts={})
            # opts part
            opts_verbose = opts.fetch :verbose, true
            ret = nil
        
            my_method=my_class.method(method_name) # Folder, :blah -> #<Method: Folder (call 'Folder.connection' to establish a connection).parse_folder_info(hash, opts=...) ./app/models/concerns/gcp_stuff_parser.rb:148>
            puts "🔬 [DB🌱v#{SeedVersion}] Parsing #{description} file: #{json_file}"
            json_buridone = JSON.parse(File.read(json_file))
            if  json_buridone.is_a? Array 
                if json_buridone.size == 0
                    puts "Empty Array - skipping. Or maybe delete this file: #{json_file}"
                    return 0
                end
                if method_name == :haruspex_autoinfer
                    haruspex_return = my_class.haruspex_autoinfer(json_buridone[0])
                    my_class,method_name = haruspex_return
                    # my_class = haruspex_return[0]
                    # method_name = haruspex_return[1]
                    puts "💣 Nuclear Launch [AUTO]detected! Haruspex seems to have worked. Calling now: #{my_class}::#{method_name} for an array of #{json_buridone.size} elements!"
                end
                # we do have an array of a generic construct which the method can parse
                json_buridone.each_with_index do |single_json_construct, ix|
                    ret = private_parse_single_json(json_file, single_json_construct, description, my_class, method_name, ix, opts)
                    if ix >= MaxIndex
                        puts "Returning from generic_parse_array_of_jsons_from_file_with_method (#{description}) after #{ix} calls, as i'm just testing and the file is HUMOUNGUSLY big (#{json_buridone.count})"
                        return ["Array out of MaxIndex: returing last of array", ret]
                    end    
                end
                puts "🖖 Finished parsing file of #{json_buridone.size} elements."
                return ["Array finished normally", ret]
            elsif json_buridone.is_a?(Hash)
                single_json_construct = json_buridone
                my_class,method_name = my_class.haruspex_autoinfer(single_json_construct) if method_name == :haruspex_autoinfer
                ret = private_parse_single_json(json_file, single_json_construct, description, my_class, method_name, 0, opts)
                return ["Hash mono-element ok", ret]
            else
                puts "❌generic_parse_array_of_jsons_from_file_with_method: probably malformed json here: #{json_file}. Investigate and delete/regenerate. json_buridone.class = #{json_buridone.class}"
                exit 49
            end
            return ret
        end
        

end 

end