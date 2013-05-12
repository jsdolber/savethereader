class SubscriptionGroup < ActiveRecord::Base
  attr_accessible :color, :name
  has_many :subscriptions
  
  validates_presence_of :name

end
