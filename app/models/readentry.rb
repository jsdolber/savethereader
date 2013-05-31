class Readentry < ActiveRecord::Base
  attr_accessible :entry_id, :subscription_id

  validates_presence_of :entry_id, :user_id, :subscription_id
  validates_uniqueness_of :entry_id, :scope => :user_id
  belongs_to :subscription
end
