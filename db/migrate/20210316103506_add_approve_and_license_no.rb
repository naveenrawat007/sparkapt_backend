class AddApproveAndLicenseNo < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :approved, :boolean, default: false
    add_column :users, :license_no, :string
    add_column :users, :city_id, :integer
  end
end
