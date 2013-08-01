class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:s, :subscription_sidebar]
  caches_action :index, :expires_in => 60.minutes

  def index
    @entries = default_feed.entries.limit(15) unless default_feed.nil?
    @groups = all_fake_groups
  end

  def s
    @subs_groups = current_user.subscription_groups
    @subs_ungroup = current_user.ungrouped_subscriptions
    @groups = @subs_groups
    @subscription_count = current_user.subscriptions.count
    render :template => 'home/index'as
  end

  private
  def all_fake_groups
    [SubscriptionGroup.new(name: "TECH"), SubscriptionGroup.new(name: "GENERAL")]
  end

  def default_feed
    Feed.find_by_url(["http://feeds.wired.com/wired/index", "http://news.ycombinator.com/rss", "http://theverge.com/rss/index.xml"].sample)
  end

end
