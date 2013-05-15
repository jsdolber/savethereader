class Feed < ActiveRecord::Base
  attr_accessible :title, :url
  belongs_to :user
  validates_presence_of :title, :url
  has_many :subscriptions, :dependent => :destroy
  has_many :entries, :dependent => :destroy

  validates_uniqueness_of :url

  def update_feed_db(feedzirra)
    return if feedzirra.entries.nil?
    
    feedzirra.entries.each do |entry|
        fentry = self.entries.find_by_guid(entry.id)
        if fentry.nil?
          new_entry = Entry.init_with_feedzirra_entry(entry)
          new_entry.feed_id = self.id
          new_entry.save!
        end
    end
  end

  def self.create_and_update(url)
    #first try to get the feeds
    feedzr = Feedzirra::Feed.fetch_and_parse(url)
    return nil if feedzr == nil || feedzr == 404
    feed = Feed.create :url => url, :title => feedzr.title
    # get the first dry run
    feed.update_feed_db(feedzr.sanitize_entries!)
    feed
  end
  
  def get_new_entry_count
    Feedzirra::Feed.fetch_and_parse(self.url).entries.count
  end
end
