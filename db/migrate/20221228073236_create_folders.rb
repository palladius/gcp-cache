class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.string :folder_id
      t.boolean :is_org
      t.string :parent_id
      t.text :description
      t.string :domain
      t.string :directory_customer_id
      t.string :lifecycle_state
      t.datetime :gcp_creation_time

      t.timestamps
    end
  end
end
