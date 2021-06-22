class AddBathDenColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :type_details, :den, :boolean, default: false
    add_column :type_details, :bath, :boolean, default: false
  end
end
