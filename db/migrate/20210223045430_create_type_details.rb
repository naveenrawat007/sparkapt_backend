class CreateTypeDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :type_details do |t|
      t.date :move_in
      t.text :notes
      t.string :price
      t.integer :type_id
      t.integer :property_id
      t.timestamps
    end
  end
end
