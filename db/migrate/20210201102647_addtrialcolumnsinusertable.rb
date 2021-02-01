class Addtrialcolumnsinusertable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_trial, :boolean, default: :false
    add_column :users, :trial_start, :datetime
    add_column :users, :trial_end, :datetime
  end
end
