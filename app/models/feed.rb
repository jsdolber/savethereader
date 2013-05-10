class Feed < ActiveRecord::Base
  attr_accessible :title, :url
  belongs_to :user
  validates_presence_of :title, :url
  has_many :subscriptions

  validates_uniqueness_of :url

  def update_feed_db(feedzirra)
    return if feedzirra.entries.nil?
    
    feedzirra.entries.each do |entry|
        fentry = self.entries.find_by_url(entry.url)
        if (fentry.nil? ||
            (fentry && fentry.published != entry.published))
          new_entry = Entry.init_with_feedzirra_entry(entry)
          new_entry.feed_id = self.id
          new_entry.save!
        end
    end
  end

end
