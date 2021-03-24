class AddFloorPlanColunn < ActiveRecord::Migration[6.0]
  def change
    add_column :properties, :floor_plan_link, :string
  end
end
