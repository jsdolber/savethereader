class AddFeedIdToReadEntry < ActiveRecord::Migration
  def change
    add_column :readentries, :feed_id, :integer
  end
end
