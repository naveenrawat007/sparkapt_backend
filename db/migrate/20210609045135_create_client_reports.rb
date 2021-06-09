class CreateClientReports < ActiveRecord::Migration[6.0]
  def change
    create_table :client_reports do |t|
      t.integer :report_id
      t.integer :client_id
      t.timestamps
    end
  end
end
