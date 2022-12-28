class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class


  def self.parse_project_info(dict)
    puts :TODO_PARSE
    pp dict
  end

  # from Folder but could come from everywhere, gence i put it here.
  # TODO move to concern -> parser :)
  def self.parse_asset_inventoy_dict(aid) # rescue nil
    puts "+++ Folder.parse_asset_inventoy_dict(asset_inventoy_dict)"
    #puts aid.keys
    puts "💛Ancestors💛: #{aid['ancestors']}"
    puts "💛AssetType💛: #{aid['asset_type']}"
    puts "💛Name💛: #{aid['name']}"
    puts "💛update_time💛: #{aid['update_time']}"
    #puts "NonNullResources: #{aid['resources']}"
    #pp aid
    #if 
end


end
