class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :description
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
