class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :user_id
end
