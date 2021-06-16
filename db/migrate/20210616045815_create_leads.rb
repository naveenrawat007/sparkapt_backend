class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :city
      t.string :name
      t.string :email
      t.string :phone
      t.string :reach_out
      t.date :move_in
      t.string :bedrooms
      t.string :bathrooms
      t.float :budget
      t.text :comment
      t.text :important_to_you, array: true, default: []
      t.string :source
      t.timestamps
    end
  end
end
