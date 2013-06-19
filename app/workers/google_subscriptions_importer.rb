class GoogleSubscriptionsImporter
  @queue = :google_importer_queue
  def self.perform(user_id, file)
   doc = Hpricot::XML(file["tempfile"].join)
   (doc/:outline).each do |entry|
    xmlUrl, title = entry.attributes["xmlUrl"], entry.attributes["title"]

    if (xmlUrl.empty?) # its a group
      title = title.truncate(20)
      current_group = SubscriptionGroup.where(:user_id => user_id, :name => title).first

      if current_group.nil?
      current_group = SubscriptionGroup.create(:name => title.gsub("\\", ""))
        current_group.user_id = user_id
        current_group.save!
      end
      
      (entry/:outline).each do |s_entry|
          s_xmlUrl = s_entry.attributes["xmlUrl"]
          s_subscription = Subscription.init(s_xmlUrl, current_group.name, user_id)
          s_subscription.save! if s_subscription.valid?
      end
    else
        new_subscription = Subscription.init(xmlUrl, nil, user_id)
        new_subscription.save! if new_subscription.valid?
    end
   end
  end
end
