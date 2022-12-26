class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :project_id
      t.string :project_number
      t.string :organization_id
      t.string :parent_id
      t.string :bialling_account_id
      t.text :description

      t.timestamps
    end
  end
end
