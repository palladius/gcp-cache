class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class


  include GcpStuffParser
  include MagicLabels
  include HaruspexMagicParser

  # you have to override me :)
  def emoji 
    '❓'
  end

   #create(attributes = nil, options = {}, &block) public
  def create(attributes = nil, options = {}, &block)
    raise "#{self.emoji} #{self.class}.create() intercepting create for buahahaha"
    super.create(attributes, options, block) do |gcp_entity|
      if attributes.keys?('labels')
        puts "gcp_entity '#{gcp_entity}' has Labels! #{attributes.labels}"
        raise "TODO implement me #figata"
      end
    end

  end


  # you have to override me :)
  def self.emoji 
    '⁉️'
  end
end
