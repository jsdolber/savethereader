class SubscriptionGroup < ActiveRecord::Base
  attr_accessible :name # :user_id,  :color
  has_many :subscriptions , :foreign_key => :group_id
  belongs_to :user
  
  validates :name, :presence => true, :length => { :in => 3..12 }
  validates :user_id, :presence => true

end
