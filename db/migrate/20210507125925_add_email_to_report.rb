class AddEmailToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :agent_email, :string
    add_column :reports, :move_in, :date
  end
end
