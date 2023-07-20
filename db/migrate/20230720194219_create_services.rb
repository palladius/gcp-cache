class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :gcp_tag
      t.integer :priority
      t.string :expected_status
      t.string :devconsole_url
      t.references :inventory_item, null: false, foreign_key: true
      t.text :description
      t.text :internal_notes

      t.timestamps
    end
  end
end
