class Subscription < ActiveRecord::Base
  attr_accessible :feed_id, :user_id
  belongs_to :user
  belongs_to :feed
  belongs_to :subscription_group

  validates_presence_of :feed_id, :user_id
end
