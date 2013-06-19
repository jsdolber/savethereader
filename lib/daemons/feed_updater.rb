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
  
  Rails.logger.info "Updating feeds at #{Time.now}.\n"

  urls = Feed.all.map {|feed| feed.url }
 
  feeds = Feedzirra::Feed.fetch_and_parse(urls)

  feeds.each { |url,feedzr|
    begin
     Rails.logger.info "Updating feed #{url} ..."
     feed = Feed.find_by_url(url)
     feed.update_feed_db(feedzr) unless feed.nil? || feedzr.class.to_s.split("::").first != "Feedzirra"
     Rails.logger.info "Completed update for feed #{url} at #{Time.now}.\n"
    rescue Exception => e
      Rails.logger.error "Error updating feed #{url}: #{e.message}"
    end
  }

  sleep 10.minutes
end
