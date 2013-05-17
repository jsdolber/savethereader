class ReadentriesController < ApplicationController
  before_filter :authenticate_user!

  # GET /readentries
  # GET /readentries.json
  def index
    @readentries = Readentry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @readentries }
    end
  end

  # GET /readentries/1
  # GET /readentries/1.json
  def show
    @readentry = Readentry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @readentry }
    end
  end

  # GET /readentries/new
  # GET /readentries/new.json
  def new
    @readentry = Readentry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @readentry }
    end
  end

  # GET /readentries/1/edit
  def edit
    @readentry = Readentry.find(params[:id])
  end

  # POST /readentries
  # POST /readentries.json
  def create
    @readentry = Readentry.new(params[:readentry])

    respond_to do |format|
      if @readentry.save
        format.html { redirect_to @readentry, notice: 'Readentry was successfully created.' }
        format.json { render json: @readentry, status: :created, location: @readentry }
      else
        format.html { render action: "new" }
        format.json { render json: @readentry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /readentries/1
  # PUT /readentries/1.json
  def update
    @readentry = Readentry.find(params[:id])

    respond_to do |format|
      if @readentry.update_attributes(params[:readentry])
        format.html { redirect_to @readentry, notice: 'Readentry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @readentry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /readentries/1
  # DELETE /readentries/1.json
  def destroy
    @readentry = Readentry.find(params[:id])
    @readentry.destroy

    respond_to do |format|
      format.html { redirect_to readentries_url }
      format.json { head :no_content }
    end
  end
end
