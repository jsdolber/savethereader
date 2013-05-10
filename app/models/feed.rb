class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :user_id
  belongs_to :user
  validates_presence_of :title, :url, :user_id
  has_many :subscriptions

end
