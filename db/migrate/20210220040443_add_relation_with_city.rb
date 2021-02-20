class AddRelationWithCity < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :city_id, :integer
  end
end
