class AddGroupIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :group_id, :integer
  end
end
