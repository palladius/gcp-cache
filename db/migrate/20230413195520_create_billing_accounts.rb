class CreateBillingAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_accounts do |t|
      t.text :description
      t.string :display_name
      t.string :master_billing_account
      t.string :name
      t.boolean :open
      t.string :baid

      t.timestamps
    end
  end
end
