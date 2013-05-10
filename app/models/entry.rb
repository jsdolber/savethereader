class Entry < ActiveRecord::Base
  attr_accessible :categories, :content, :feed_id, :published, :summary, :title, :url

  validates_presence_of :feed_id, :title, :summary, :url, :published
end
