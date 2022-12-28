class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.string :gcp_key
      t.string :gcp_value

      t.timestamps
    end
  end
end
