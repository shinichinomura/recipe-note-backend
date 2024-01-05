class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user_account, null: false
      t.string :title, null: false
      t.string :url, null: false
      t.datetime :registered_at, null: false

      t.timestamps null: false
    end

    add_foreign_key :recipes, :user_accounts,
                    column: :user_account_id, on_delete: :cascade, on_update: :cascade
  end
end
