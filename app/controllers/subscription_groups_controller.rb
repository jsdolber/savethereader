class SubscriptionGroupsController < ApplicationController
  before_filter :authenticate_user!

  # GET /subscription_groups
  # GET /subscription_groups.json
  def index
    @subscription_groups = SubscriptionGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscription_groups }
    end
  end

  # GET /subscription_groups/1
  # GET /subscription_groups/1.json
  def show
    @subscription_group = SubscriptionGroup.find(params[:id])

    respond_to do |format|
      format.json { render json: @subscription_group }
    end
  end

  # GET /subscription_groups/new
  # GET /subscription_groups/new.json
  def new
    @subscription_group = SubscriptionGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription_group }
    end
  end

  # GET /subscription_groups/1/edit
  def edit
    @subscription_group = SubscriptionGroup.find(params[:id])
  end

  # POST /subscription_groups
  # POST /subscription_groups.json
  def create
    @subscription_group = SubscriptionGroup.new(params[:subscription_group])
    @subscription_group.user_id = current_user.id
    respond_to do |format|
      if @subscription_group.save
        format.json { render json: @subscription_group, status: :created, location: @subscription_group }
      else
        format.json { render json: @subscription_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscription_groups/1
  # PUT /subscription_groups/1.json
  def update
    @subscription_group = SubscriptionGroup.find(params[:id])

    respond_to do |format|
      if @subscription_group.update_attributes(params[:subscription_group])
        format.html { redirect_to @subscription_group, notice: 'Subscription group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscription_groups/1
  # DELETE /subscription_groups/1.json
  def destroy
    @subscription_group = SubscriptionGroup.find(params[:id])
    @subscription_group.destroy

    respond_to do |format|
      format.html { redirect_to subscription_groups_url }
      format.json { head :no_content }
    end
  end
end
