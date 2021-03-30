class AddStatusForClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :name, :string
    add_column :clients, :status, :string
    add_column :properties, :google_review_link, :text
    add_column :properties, :send_escort, :float
  end
end
