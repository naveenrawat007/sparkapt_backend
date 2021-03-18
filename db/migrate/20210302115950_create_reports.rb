class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :report_code
      t.text :message
      t.text :property_ids, array: true, default: []
      t.string :name
      t.timestamps
    end
    add_index :reports, :report_code, unique: true
  end
end
