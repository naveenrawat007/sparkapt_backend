class AddBrokregeField < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :brokerage_name, :string
  end
end
