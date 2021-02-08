class CreateContactinquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :contactinquiries do |t|
      t.string :email
      t.string :phone
      t.string :inquiry_reason
      t.text :message
      t.timestamps
    end
  end
end
