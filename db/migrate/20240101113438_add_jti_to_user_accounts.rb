class AddJtiToUserAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :user_accounts, :jti, :string, after: :password_digest
  end
end
