class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:s, :subscription_sidebar] 

  def index
    default_feed = Feed.find_by_url("http://stackoverflow.com/feeds")
    @entries = default_feed.entries.limit(15) unless default_feed.nil?
    @groups = all_fake_groups
  end

  def s
    @subs_groups = current_user.subscription_groups
    @subs_ungroup = current_user.subscriptions.where(:group_id => nil)
    @groups = @subs_groups
    @subscription_count = current_user.subscriptions.count
    render :template => 'home/index'
  end

  private
  def all_fake_groups
    [SubscriptionGroup.new(name: "TECH"), SubscriptionGroup.new(name: "GENERAL")]
  end

end
