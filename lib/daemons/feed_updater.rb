#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  Rails.logger.auto_flushing = true
  Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  urls = Feed.find(:all).map {|feed| feed.url }
 
  feeds = Feedzirra::Feed.fetch_and_parse(urls)

  feeds.each { |url,feedzr|
    feed = Feed.find_by_url(url)

    unless feed.nil? 
      feed.update_feed_db(feedzr.sanitize_entries!)
    end

  }

  sleep 60 * 10 # every ten minutes
end
