class SubscriptionGroup < ActiveRecord::Base
  attr_accessible :color, :name, :user_id
  has_many :subscriptions , :foreign_key => :group_id
  belongs_to :user
  
  validates_presence_of :name

end
