# automatically parses with right function based on keys of hash being parsed.
module HaruspexMagicParser     
    extend ActiveSupport::Concern

    HaruspexMagicParserVersion = '0.0.1'

    DbSeedMagicSignature30dec22 = {
        :parse_asset_inventory_dict=>  ["ancestors", "asset_type", "name", "resource", "update_time"],
        :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
        :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
        :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
        :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
    }
    DbSeedMagicSignature30dec22 = {
        :parse_asset_inventory_dict =>  ["ancestors", "asset_type", "name", "resource", "update_time"],
        :parse_project_info=> ["createTime", "lifecycleState", "name", "parent", "projectId", "projectNumber"],
        :parse_organization_info=> ["creationTime", "displayName", "lifecycleState", "name", "owner"],
        :parse_folder_info=> ["createTime", "displayName", "lifecycleState", "name", "parent"],
        :parse_asset_inventory_dict_from_gcloud=> ["assetType", "createTime", "description", "displayName", "location", "name", "parentAssetType", "parentFullResourceName", "project", "updateTime"]
    }
    #asset_inventory_parser.rb:

included do

    # This is the summa of Riccardo ability to write good, unreadable code :) 
    # We're autoinferring what function to call based on the hash keys shape.
    # This would be much easier if the keys stayed the same :)
    # Should return a copule Class and Method :) 
    def self.haruspex_autoinfer(hash, opts={})
        opts_verbose = opts.fetch :verbose, false
        raise "haruspex_autoinfer(): Expecting a hash, got a #{hash.class}" unless hash.class == Hash
        # this is the summa of all the knowledge I got from parsing EXISTING stuff. UYou need to maintain a better version..

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
        pp matching_methods if opts_verbose
        exit 43
    end

end 

end