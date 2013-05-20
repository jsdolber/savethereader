class Readentry < ActiveRecord::Base
  attr_accessible :entry_id, :user_id, :subscription_id

  validates_presence_of :entry_id, :user_id, :subscription_id
  belongs_to :subscription
end
