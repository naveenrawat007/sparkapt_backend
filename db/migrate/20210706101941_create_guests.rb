class CreateGuests < ActiveRecord::Migration[6.0]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.date :move_in
      t.float :budget
      t.integer :pet_number
      t.string :pet_type
      t.string :pet_name
      t.string :communities
      t.text :preferences
      t.timestamps
    end
  end
end
