class AddGeneralIndexes < ActiveRecord::Migration
  def up
    add_index :subscriptions, :feed_id
    add_index :subscriptions, :group_id
    add_index :subscriptions, :user_id
    add_index :entries, :feed_id
    add_index :readentries, :subscription_id
    add_index :readentries, :user_id
    add_index :subscription_groups, :user_id
  end

  def down
    remove_index :subscriptions, :feed_id
    remove_index :subscriptions, :group_id
    remove_index :subscriptions, :user_id
    remove_index :entry, :feed_id
    remove_index :readentries, :subscription_id
    remove_index :readentries, :user_id
    remove_index :subscription_groups, :user_id
  end
end
