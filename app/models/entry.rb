class Entry < ActiveRecord::Base
  attr_accessible :categories, :content, :feed_id, :published, :summary, :title, :url
end
