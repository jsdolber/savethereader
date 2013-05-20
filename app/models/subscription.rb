class Subscription < ActiveRecord::Base
  attr_accessible :feed_id, :user_id, :group_id
  belongs_to :user
  belongs_to :feed
  belongs_to :subscription_group
  has_many :readentry, :dependent => :destroy
  validates_presence_of :feed_id, :user_id
  validates_uniqueness_of :feed_id, :scope => :user_id

  def self.init(url, group, user_id)
    # first check if feed exists
    feed = Feed.find_by_url(url)
    feed = Feed.create_and_update url if feed.nil?
    # return if it didn't succeed creating feed
    return Subscription.new if feed.nil? 
    new_sub = Subscription.new :feed_id => feed.id, :user_id => user_id
    new_sub.group_id = new_sub.user.subscription_groups.find_by_name(group).id if !group.nil? && new_sub.user.subscription_groups.exists?(:name => group)
    new_sub
  end

  def unread_count
    r_entries = Readentry.where(:user_id => self.user.id, :subscription_id => self.id).collect {|re| re.entry_id }
    entries = feed.entries.all.collect { |entry| entry.id } #watch out for scaling issues
    (entries - r_entries).count
  end

end
