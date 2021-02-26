class Addcodecolumn < ActiveRecord::Migration[6.0]
  def change
    add_column :types, :type_code, :string
  end
end
