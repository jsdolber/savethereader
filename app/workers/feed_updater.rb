class FeedUpdater
  @queue = :feed_updater_queue
  def self.perform
      logger = Rails.logger
      logger.info "Updating feeds at #{Time.now}.\n"

      urls = Feed.all.map {|feed| feed.url }
     
      urls.each { |url|
        begin
         logger.info "Updating feed #{url} ..."
         feedzr = Feedzirra::Feed.fetch_and_parse(url)
         feed = Feed.find_by_url(url)
         feed.update_feed_db(feedzr) unless feed.nil? || feedzr.class.to_s.split("::").first != "Feedzirra"
         logger.info "Completed update for feed #{url} at #{Time.now}.\n"
        rescue Exception => e
         logger.error "Error updating feed #{url}: #{e.message}"
        end
      }
  end
end
