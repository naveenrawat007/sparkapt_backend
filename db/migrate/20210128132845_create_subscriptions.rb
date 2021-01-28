class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.boolean :active, default: false
      t.datetime :current_start_datetime
      t.datetime :current_end_datetime
      t.string :status
      t.string :stripe_subscription_id
      t.integer :user_id
      t.integer :plan_id
      t.timestamps
    end
  end
end
