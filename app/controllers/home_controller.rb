class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:s]

  def index
    @feed = Feedzirra::Feed.fetch_and_parse("http://stackoverflow.com/feeds").sanitize_entries! #feed by default
    @groups = all_groups
  end

  def s
    @subs_groups = current_user.subscription_groups
    @subs_ungroup = current_user.subscriptions.where(:group_id => nil)
    @groups = all_groups
    @user = current_user
    render :template => 'home/index'
  end

  private
  def all_groups
     SubscriptionGroup.all
  end
end
