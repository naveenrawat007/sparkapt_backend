class ChangeDataType < ActiveRecord::Migration[6.0]
  def change
    change_column :properties, :price, 'float USING CAST(price AS float)'
    change_column :properties, :built_year, 'integer USING CAST(price AS integer)'
    change_column :properties, :escort, 'float USING CAST(escort AS float)'

  end
end
