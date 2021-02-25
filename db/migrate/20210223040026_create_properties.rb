class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :phone
      t.string :specials
      t.string :price
      t.string :submarket
      t.string :zip
      t.string :built_year
      t.string :escort
      t.string :management_company
      t.string :web_link
      t.string :manager_name
      t.string :email
      t.string :google_rating
      t.string :google_map
      t.boolean :w_d_include
      t.integer :city_id
      t.timestamps
    end
  end
end
