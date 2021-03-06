module HomeHelper
  def display_public_sidebar_feeds
    content_tag(:ul, :class => "nav nav-list sidebar-nav affix-top") do
      concat(label_to_li_grp("Tech", 0)) +
      ['Stack Overflow', 'Hacker News', 'Techcrunch'].collect do |member|
        concat(label_to_li(member, '#', nil, nil))
      end +
      concat(label_to_li_grp("General", 0)) +
      ['Wired', 'Slashdot', 'Torrent Freak'].collect do |member|
        concat(label_to_li(member, '#', nil, nil))
      end
    end
  end

  def display_user_no_count_sidebar_feeds(subs_groups, subs_ungroup)
      display_user_sidebar_feeds(subs_groups, subs_ungroup, false)
  end

  def display_user_with_count_sidebar_feeds(subs_group, subs_ungroup)
      display_user_sidebar_feeds(subs_group, subs_ungroup, true)
  end

  def display_user_sidebar_feeds(subs_group, subs_ungroup, show_count)
    content_tag(:ul, :class => "nav nav-list sidebar-nav affix-top") do
      subs_group.each do |group|
        #unless group.subscriptions.empty?
          concat(label_to_li_grp(group.name, group.id)) +
          group.subscriptions.collect do |subs|
            unread_cnt = show_count ? subs.unread_count : nil
            concat(label_to_li(subs.feed.title, subs.feed.url, subs.id, unread_cnt))
          end  
        # end      
      end unless subs_group.nil? || subs_group.empty? 
      concat(label_to_li_grp("Uncategorized", 0)) +
      subs_ungroup.collect do |subs|
         unread_cnt = show_count ? subs.unread_count : nil
         concat(label_to_li(subs.feed.title, subs.feed.url, subs.id, unread_cnt))
      end unless subs_ungroup.nil? || subs_ungroup.empty?
    end 
  end

  def label_to_li(label, url, subs_id, unread_cnt)
      content_tag(:li, :class => 'feed-link', :id => subs_id) do
         content_tag(:a, :href => "##{url}") do
          feed_item_icon + 
          label +
          unless unread_cnt.nil? || unread_cnt == 0
            unread_count_icon(unread_cnt)
          end
         end
      end
  end

  def label_to_li_grp(label, group_id)
      content_tag(:li, :class => "nav-header group", :id => "#{group_id}") do
        label
      end
  end
 
  private
  def feed_item_icon
    content_tag("i", :class => "icon-chevron-right") do
    end
  end

  def unread_count_icon(count)
     content_tag(:span, :class => 'unreadcnt') do 
       count.to_s 
     end
  end

end
