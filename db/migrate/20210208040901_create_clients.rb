class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.integer :user_id
      t.string :last_name
      t.date :move_in_date
      t.string :email
      t.string :phone
      t.text :notes
      t.string :budget
      t.timestamps
    end
  end
end
