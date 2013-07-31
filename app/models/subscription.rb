class Subscription < ActiveRecord::Base
  attr_accessible :feed_id, :user_id, :group_id
  belongs_to :user
  belongs_to :feed
  belongs_to :subscription_group
  has_many :readentry, :dependent => :destroy
  validates_presence_of :feed_id, :user_id
  validates_uniqueness_of :feed_id, :scope => :user_id
  validate :subscription_limit_reached, :on => :create
  after_touch :destroy_unread_cache
  after_create :destroy_unread_cache

  def self.init(url, group, user_id)
    # first check if feed exists
    feed = Feed.find_by_url_with_feedbag(url)
    feed = Feed.create_and_update url if feed.nil?
    # return if it didn't succeed creating feed
    return Subscription.new if feed.nil? 
    new_sub = Subscription.new :feed_id => feed.id, :user_id => user_id
    new_sub.group_id = new_sub.user.subscription_groups.find_by_name(group).id if !group.nil? && new_sub.user.subscription_groups.exists?(:name => group)
    new_sub
  end

  def unread_count
    return read_unread_number_cache unless read_unread_number_cache.nil?
    r_entries = read_entries.collect {|re| re.entry_id }
    entries = self.feed.entries.where('updated_at > ?', self.updated_at).collect { |entry| entry.id } #watch out for scaling issues
    unread = (entries - r_entries).count
    write_unread_number_cache unread
    unread
  end

  def get_entries(page_num, per_page)
    self.feed.cached_entries(page_num, per_page)
  end

  def self.import(subscriptions, user_id)
    subscriptions.each do |provider, s_file|
      case provider.to_sym
      when :google
        Subscription.import_from_google(s_file, user_id)
      else
        logger.error("no received provider")
      end
    end
  end

  def destroy_unread_cache
    Rails.cache.delete unread_number_cache_key
  end

  private
  def get_unread_entries(page_num, per_page)
    return nil if self.unread_count == 0
    r_entries = read_entries.collect {|re| re.entry_id }
    entries = self.feed.entries.paginate(page: page_num || 1, per_page: per_page || 10, order: 'created_at DESC').to_a
    return entries.keep_if {|e| !r_entries.include? e.id }
  end

  def read_entries
     Readentry.where(:user_id => self.user.id, :subscription_id => self.id)
  end

  def self.import_from_google(file, user_id)
    begin
      Resque.enqueue(GoogleSubscriptionsImporter, user_id, file )
    rescue Exception => e
      logger.error('importing subscriptions ' + e.message)
    end
  end

  # cache methods
  def write_unread_number_cache(num)
    Rails.cache.write unread_number_cache_key, num, :expires_in => 10.minutes
  end

  def read_unread_number_cache
    Rails.cache.read unread_number_cache_key 
  end

  def unread_number_cache_key
    "#{self.id}_unread"
  end

  # validate methods
  def subscription_limit_reached
    errors.add(:user_id, "subscription limit reached") unless Subscription.where(:user_id => self.user_id).count < 250
  end

end
