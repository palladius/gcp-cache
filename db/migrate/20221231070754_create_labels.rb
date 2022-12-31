
# Ricc pseudo copied/adapted from: https://guides.rubyonrails.org/association_basics.html
class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.string :gcp_k
      t.string :gcp_val
      #t.bigint :labellable_id
      #t.string :labellable_type
      t.references :labellable, polymorphic: true

      t.timestamps
    end

    #add_index :labels, [:labellable_type, :labellable_id]
  end
end
