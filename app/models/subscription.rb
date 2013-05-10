class Subscription < ActiveRecord::Base
  attr_accessible :feed_id, :user_id
  belongs_to :user
  belongs_to :feed

  validates_presence_of :feed_id, :user_id
end
