class Subscription < ActiveRecord::Base
  attr_accessible :feed_id, :user_id, :group_id
  belongs_to :user
  belongs_to :feed
  belongs_to :subscription_group
  has_many :readentry, :dependent => :destroy
  validates_presence_of :feed_id, :user_id
  validates_uniqueness_of :feed_id, :scope => :user_id
  validate :subscription_limit_reached, :on => :create

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
    r_entries = read_entries.collect {|re| re.entry_id }
    entries = feed.entries.all.collect { |entry| entry.id } #watch out for scaling issues
    (entries - r_entries).count
  end

  def get_entries(page_num, per_page, show_read)
    return get_unread_entries(page_num, per_page) unless show_read
    get_all_entries(page_num, per_page)
  end

  def self.import(subscriptions, user_id)
    subscriptions.each do |provider, s_file|
      case provider.to_sym
      when :google
        Subscription.import_from_google(s_file.tempfile, user_id)
      else
        logger.error("no received provider")
      end
    end
  end

  private
  def get_all_entries(page_num, per_page)
    self.feed.entries.paginate(page: page_num || 1, per_page: per_page || 15, order: 'created_at DESC')
  end

  def get_unread_entries(page_num, per_page)
    return nil if self.unread_count == 0
    r_entries = read_entries.collect {|re| re.entry_id }
    q_conditions = r_entries.count == 0 ? nil :  ['id not in (?)', r_entries]
    self.feed.entries.paginate(page: page_num || 1, per_page: per_page || 15, conditions: q_conditions, order: 'created_at DESC')
  end

  def read_entries
     Readentry.where(:user_id => self.user.id, :subscription_id => self.id)
  end

  def self.import_from_google(file, user_id)
    begin
     doc = Hpricot::XML(file)
     (doc/:outline).each do |entry|
        xmlUrl, title = entry.attributes["xmlUrl"], entry.attributes["title"]

        if (xmlUrl.empty?) # its a group
          title = title.truncate(20)
          current_group = SubscriptionGroup.where(:user_id => user_id, :name => title).first

          if current_group.nil?
            current_group = SubscriptionGroup.create(:name => title)
            current_group.user_id = user_id
            current_group.save!
          end
          
          (entry/:outline).each do |s_entry|
              s_xmlUrl = s_entry.attributes["xmlUrl"]
              s_subscription = Subscription.init(s_xmlUrl, current_group.name, user_id)
              s_subscription.save! if s_subscription.valid?
          end
        else
          new_subscription = Subscription.init(xmlUrl, nil, user_id)
          new_subscription.save! if new_subscription.valid?
        end
     end
    rescue Exception => e
      logger.error('reading subscriptions ' + e.message)
      nil
    end
  end

  # validate methods
  def subscription_limit_reached
    errors.add(:user_id, t("subscription limit reached")) unless Subscription.where(:user_id => self.user_id).count < 250
  end

end
