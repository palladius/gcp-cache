class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.string :gcp_k
      t.string :gcp_val
      t.integer :labellable_id
      t.string :labellable_type

      t.timestamps
    end
  end
end
