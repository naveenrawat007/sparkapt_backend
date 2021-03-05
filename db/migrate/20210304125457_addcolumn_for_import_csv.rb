class AddcolumnForImportCsv < ActiveRecord::Migration[6.0]
  def change
    add_column :properties, :address, :text
    add_column :type_details, :size, :float
    add_column :type_details, :floor_plan, :string
    add_column :type_details, :available, :string
  end
end
