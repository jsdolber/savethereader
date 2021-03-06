class SubscriptionGroup < ActiveRecord::Base
  attr_accessible :name # :user_id,  :color
  has_many :subscriptions , :foreign_key => :group_id
  belongs_to :user
  after_create :invalidate_user_subs_groups_cache
  validates :name, :presence => true, :length => { :in => 3..20 }
  validates :user_id, :presence => true
  validates_uniqueness_of :name, :scope => :user_id

  def invalidate_user_subs_groups_cache
    self.user.invalidate_subs_groups_cache
  end

end
