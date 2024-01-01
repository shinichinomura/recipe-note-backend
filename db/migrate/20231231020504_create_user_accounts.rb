class CreateUserAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accounts do |t|
      t.string :display_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :registered_at, null: false
      t.datetime :resigned_at

      t.timestamps null: false
    end
  end
end
