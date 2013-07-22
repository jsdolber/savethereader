class FeedSweeper < ActionController::Caching::Sweeper
 
  observe Feed
 
  def after_update(record)  expire_feed_cache(record) ; end 
 
  def expire_feed_cache(record)
    ActionController::Base.new.expire_fragment "series/#{series.id}/episodes"
  end 
 
end
