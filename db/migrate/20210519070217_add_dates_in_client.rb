class AddDatesInClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :lease_end_date, :date
    add_column :clients, :next_follow_up, :datetime
  end
end
