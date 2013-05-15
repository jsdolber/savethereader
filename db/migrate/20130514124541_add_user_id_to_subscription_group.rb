class AddUserIdToSubscriptionGroup < ActiveRecord::Migration
  def change
    add_column :subscription_groups, :user_id, :integer
  end
end
