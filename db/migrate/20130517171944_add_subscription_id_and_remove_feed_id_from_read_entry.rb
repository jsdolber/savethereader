class AddSubscriptionIdAndRemoveFeedIdFromReadEntry < ActiveRecord::Migration
  def change
    remove_column :readentries, :feed_id
    add_column :readentries, :subscription_id, :integer
  end
end
