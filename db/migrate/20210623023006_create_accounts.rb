class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :user_id
      t.decimal :amount

      t.timestamps
    end
  end
end
