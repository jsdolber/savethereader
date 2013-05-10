class AddGroupToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :group, :string
  end
end
