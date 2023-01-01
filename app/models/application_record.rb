class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class


  include GcpStuffParser
  include MagicLabels
  include HaruspexMagicParser

  # you have to override me :)
  def emoji 
    '❓'
  end

  # you have to override me :)
  def self.emoji 
    '⁉️'
  end
end
