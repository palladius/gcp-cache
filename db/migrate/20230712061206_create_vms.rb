class CreateVms < ActiveRecord::Migration[7.0]
  def change
    create_table :vms do |t|
      t.string :name
      t.text :description
      t.text :internal_notes
      t.string :machine_type
      t.string :internal_ip
      t.string :external_ip
      t.string :self_link
      t.string :zone
      t.integer :disk1_size_gb
      t.string :disk1_name
      t.string :status
      t.boolean :is_preemptible
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
