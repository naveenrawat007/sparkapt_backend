class AddVaRoleInUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_va, :boolean, default: false
  end
end
