class CreatePropertyTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :property_types do |t|
      t.belongs_to :property
      t.belongs_to :type
      t.timestamps
    end
  end
end
