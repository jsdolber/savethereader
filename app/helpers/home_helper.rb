module HomeHelper
  def display_public_sidebar_feeds
    content_tag(:ul, :class => "nav nav-list bs-docs-sidenav sidebar-nav sidebar-nav-fixed affix-top") do
      concat(label_to_li_grp("Tech")) +
      ['Coding Horror', 'Hacker News', 'Techcrunch'].collect do |member|
        concat(label_to_li(member, '#', nil, nil))
      end +
      concat(label_to_li_grp("General")) +
      ['Wired', 'Slashdot', 'Torrent Freak'].collect do |member|
        concat(label_to_li(member, '#', nil, nil))
      end
    end
  end

  def display_user_sidebar_feeds(subs_group, subs_ungroup)
    content_tag(:ul, :class => "nav nav-list sidebar-nav affix-top") do
      subs_group.each do |group|
        unless group.subscriptions.empty?
          concat(label_to_li_grp(group.name)) +
          group.subscriptions.collect do |subs|
            concat(label_to_li(subs.feed.title, subs.feed.url, subs.id, subs.unread_count))
          end  
        end      
      end 
      concat(label_to_li_grp("Uncategorized")) +
      subs_ungroup.collect do |subs|
         concat(label_to_li(subs.feed.title, subs.feed.url, subs.id, subs.unread_count))
      end 
    end unless (subs_ungroup.nil? || subs_ungroup.empty?)
  end

  private
  def label_to_li(label, url, subs_id,unread_cnt)
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

  def label_to_li_grp(label)
      content_tag(:li, :class => "nav-header") do
        label
      end
  end

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
