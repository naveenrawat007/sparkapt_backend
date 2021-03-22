class AddAppovedColumnInUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :status, :string
    remove_column :users, :is_trial, :boolean
    remove_column :users, :trial_start, :datetime
    remove_column :users, :trial_end, :datetime
  end
end
