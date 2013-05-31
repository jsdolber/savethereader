class CreateSubscriptionGroups < ActiveRecord::Migration
  def change
    create_table :subscription_groups do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
