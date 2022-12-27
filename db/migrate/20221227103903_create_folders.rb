class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.string :folder_id
      t.boolean :is_org, default: false
      t.string :parent_id
      t.text :description

      t.timestamps
    end
  end
end
