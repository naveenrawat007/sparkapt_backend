class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.float :amount
      t.string :stripe_plan_id
      t.boolean :is_trial, default: false
      t.string :interval
      t.timestamps
    end
  end
end
