class AddLogoSignInUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :signature, :string
    add_attachment :users, :logo
    add_column :guests, :user_id, :integer
  end
end
