class AddActiveToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :active, :boolean, :null => false, :default => true
  end
end
