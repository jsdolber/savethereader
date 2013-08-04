class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  require_dependency 'entry'
  #caches_action :show, :cache_path => custom_cache_path.to_proc

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscriptions/1.js
  def show
    @subscription = Subscription.find(params[:id])
    @entries = @subscription.get_entries(params[:page], params[:per_page])
    @subscription_id = @subscription.id
    @user_id = current_user.id
    respond_to do |format|
      format.js
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = params[:subscription].nil?? Subscription.init(params[:url], params[:group], current_user.id) : Subscription.new(params[:subscription]) 
    respond_to do |format|
      if @subscription.save
        format.json { render json: @subscription, :include => [:subscription_group, :feed], :methods => :unread_count, status: :created, location: @subscription }
      else
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # GET /subscriptions/import
  def import

  end

  # POST /subscriptions/upload_import
  def upload_import
    respond_to do |format|
      if Subscription.import(params[:file], current_user.id)
        format.html { redirect_to root_path, notice: 'Your subscriptions are being imported. They will start appearing on your sidebar shortly.' }
        format.json { head :no_content }
      else
        format.html { render action: "import", error: 'Unable to process import.' }
        format.json { render json: { message: "Unable to process import." }, status: :unprocessable_entity }
      end
    end
  end

  # POST /subscriptions/set_show_read.json
  def set_show_read
    show_read_toggle(to_boolean(params[:state]))

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # GET /sidebar.js
  def sidebar
    @subs_groups = current_user.cached_subscription_groups
    @subs_ungroup = current_user.cached_ungrouped_subscriptions
    respond_to do |format|
      format.js
    end
  end

  # POST /subscriptions/mark_all_read.json
  def mark_all_read
    subscription = Subscription.find(params[:id])

    subscription.touch unless subscription.nil?

    respond_to do |format|
      format.json { head :no_content }
    end

  end

  def custom_cache_path
    "#{params[:id]}-#{params[:page]}-#{params[:controller]}-#{params[:action]}"
  end

  private
  def show_read
    session[:show_read] || false
  end

  def show_read_toggle(state)
    session[:show_read] = state
  end

  def to_boolean(str)
      str == 'true'
  end

end
