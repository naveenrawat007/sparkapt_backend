class Addlatlngcolumninproperty < ActiveRecord::Migration[6.0]
  def change
    add_column :properties, :lat, :float
    add_column :properties, :long, :float
  end
end
