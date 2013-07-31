class Feed < ActiveRecord::Base
  attr_accessible :title, :url
  belongs_to :user
  validates_presence_of :title, :url
  has_many :subscriptions, :dependent => :destroy
  has_many :entries, :dependent => :destroy
  has_many :entries
  NUM_OF_CACHED_PAGES = 10

  validates_uniqueness_of :url

  def cached_entries(page_num, per_page)
    page_num = 1 if page_num.nil?
    # try to retrieve from cache
    entries = get_cached_entries(page_num)
    return entries unless entries.nil?

    entries = self.entries.paginate(page: page_num || 1, per_page: per_page || 10, order: 'created_at DESC')
    set_cached_entries(page_num, entries) if page_num.to_i <= NUM_OF_CACHED_PAGES # only store until num_of_cache_pages
    return entries
  end

  def get_cached_entries(page_num)
    Rails.cache.read "#{self.id}-#{page_num}"
  end

  def set_cached_entries(page_num, entries)
    Rails.cache.write "#{self.id}-#{page_num}", entries.to_a
  end

  def remove_all_cached_entries
    NUM_OF_CACHED_PAGES.times do |page_num|
      Rails.cache.delete "#{self.id}-#{page_num}"
    end
  end

  def update_feed_db(feedzirra)
    return if feedzirra.entries.nil?
    has_updated = false 
    feedzirra.entries.each do |entry|
        fentry = self.entries.find_by_guid(entry.id)
        if fentry.nil?
          new_entry = Entry.init_with_feedzirra_entry(entry)
          new_entry.feed_id = self.id
          if new_entry.save
            has_updated = true
          end
        end
    end

    remove_all_cached_entries if has_updated

  end

  def self.create_and_update(url)
    begin
      #first try to get the feed
      url = Feed.find_url_with_feedbag(url)
      feedzr = Feedzirra::Feed.fetch_and_parse(url)
      return nil if feedzr.nil? || feedzr.class.to_s.split("::").first != "Feedzirra"

      feed = Feed.create :url => url, :title => feedzr.title
      # get the first dry run
      feed.update_feed_db(feedzr)
      feed
    rescue Exception => e
      logger.error('problem creating feed: ' + e.message)
      nil
    end
  end
  
  def get_new_entry_count
    Feedzirra::Feed.fetch_and_parse(self.url).entries.count
  end

  def self.find_by_url_with_feedbag(url)
    Feed.find_by_url(Feed.find_url_with_feedbag(url))
  end

  def self.find_url_with_feedbag(url)
    begin
      feedbag_url = Feedbag.find(url).first
    rescue
      logger.error('returning original url because: ' + e.message)
    end

    feedbag_url || url
  end

end
