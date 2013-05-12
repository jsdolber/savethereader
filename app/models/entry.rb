class Entry < ActiveRecord::Base
  attr_accessible :categories, :content, :feed_id, :published, :summary, :title, :url, :guid

  validates_presence_of :feed_id, :title, :summary, :url, :published, :guid

  validates_uniqueness_of :guid

  def self.init_with_feedzirra_entry(entry)
    new_entry = Entry.new
    new_entry.guid = entry.id
    new_entry.title = entry.title
    new_entry.summary = entry.summary
    new_entry.url = entry.url
    new_entry.content = entry.content
    new_entry.published = entry.published
    new_entry
  end
end
