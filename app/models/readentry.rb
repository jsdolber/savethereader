class Readentry < ActiveRecord::Base
  attr_accessible :entry_id, :subscription_id
  after_create :invalidate_unread_cache

  validates_presence_of :entry_id, :user_id, :subscription_id
  validates_uniqueness_of :entry_id, :scope => :user_id
  belongs_to :subscription

  def invalidate_unread_cache
    self.subscription.destroy_unread_cache
  end
end
