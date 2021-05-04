class AddRennovatedColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :properties, :renovated, :integer
  end
end
