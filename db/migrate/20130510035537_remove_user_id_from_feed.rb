class RemoveUserIdFromFeed < ActiveRecord::Migration
  def up
    remove_column :feeds, :user_id
  end

  def down
    add_column :feeds, :user_id, :integer
  end
end
