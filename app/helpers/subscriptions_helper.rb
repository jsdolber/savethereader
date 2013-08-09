module SubscriptionsHelper
  def reached_page_limit(page)
    page.to_i > 50
  end

end
