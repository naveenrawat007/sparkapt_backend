class AddPropertyTypeColumnInTypeDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :type_details, :property_type_name, :string
  end
end
