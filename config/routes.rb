Savethereader::Application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  match 'sidebar' => 'subscriptions#sidebar', :as => :sidebar, :via => :get
  match 'subscriptions/set_show_read' => 'subscriptions#set_show_read', :as => :set_show_read, :via => :post
  match 'subscriptions/import' => 'subscriptions#import', :as => :import, :via => :get
  match 'subscriptions/upload_import' => 'subscriptions#upload_import', :as => :upload_import, :via => :post
  match 'subscriptions/mark_all_read' => 'subscriptions#mark_all_read', :as => :mark_all_unread, :via => :post


  resources :subscriptions, :except => [:index, :new, :edit, :update] 
  resources :readentries, :only => [:create, :show]
  resources :subscription_groups, :only => [:create, :show]

  authenticated :user do
    root :to => "home#s"
  end

  root :to => 'home#index'


  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
