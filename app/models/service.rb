class Service < ApplicationRecord
  belongs_to :inventory_item, required: false

  #before_save
end
