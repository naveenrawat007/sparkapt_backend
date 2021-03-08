class ChangeColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :type_details, :price, 'float USING CAST(price AS float)'
  end
end
