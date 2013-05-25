module ApplicationHelper
  def show_read
    session[:show_read].nil?? false : session[:show_read]
  end

  def get_classes_for_container
    # use span11 to reduce margin on left in home view
    # use span12 for the rest of the pages to be aligned, could be extend for no-sidebar pages
    user_signed_in?? "" : (params[:controller] == "home" ? "span12 pull-right" : "span11 pull-right") 
  end
end
