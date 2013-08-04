class User < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :subscription_groups, :dependent => :destroy
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def cached_subscription_groups
    groups = Rails.cache.read subs_group_cache_key

    if groups.nil?
      groups = self.subscription_groups
      Rails.cache.write groups, subs_group_cache_key
    end
    
    groups 
  end

  def cached_ungrouped_subscriptions
    groups = Rails.cache.read subs_ungroup_cache_key

    if groups.nil?
      groups = self.ungrouped_subscriptions
      Rails.cache.write groups, subs_ungroup_cache_key
    end
    
    groups

  end

  def cached_subscription_count
    count = Rails.cache.read subs_group_count_cache_key

    if count.nil?
      count = self.subscriptions.count
      Rails.cache.write count, subs_group_count_cache_key
    end
    
    count 

  end

  def ungrouped_subscriptions
    self.subscriptions.where(:group_id => nil)
  end

  def invalidate_subs_groups_cache
    Rails.cache.delete subs_group_cache_key
    Rails.cache.delete subs_ungroup_cache_key
    Rails.cache.delete subs_group_count_cache_key
  end

  def subs_group_cache_key
    "#{self.id}_groups"
  end

  def subs_ungroup_cache_key
    "#{self.id}_ungroups"
  end

  def subs_group_count_cache_key
    "#{self.id}_group_count"
  end

end
