class RemoveGroupFromSubscription < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :group
  end

  def down
    add_column :subscriptions, :group, :string
  end
end
