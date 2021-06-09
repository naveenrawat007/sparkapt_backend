class AddAssociationForUserReportClient < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :title, :string
    add_column :reports, :is_show, :boolean, default: false
  end
end
