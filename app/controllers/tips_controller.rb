class TipsController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :browse]
  
  # GET /tips
  # GET /tips.xml
  def index
    @start_time = Time.now
    @tips, @search_time, @search_split = Tip.search params[:search], params[:user], session[:user], request.remote_ip
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
    end
  end
  
  def browse
    limit = 10
    offset = (params[:page].to_i-1) * limit
    @num_of_pages = (Tip.count.to_f / limit.to_f).ceil
    @tips = Tip.find(:all, :order => "content", :limit => limit, :offset => offset)
    respond_to do |format|
      format.html { render :action => "index" }
    end
  end

  # GET /tips/1
  # GET /tips/1.xml
  def show
    @tip = Tip.find(params[:id])
    if !@tip.nil?
      @tip.pageloads+=1
      @tip.save
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/new
  # GET /tips/new.xml
  def new
    @tip = Tip.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/1/edit
  def edit
    @tip = Tip.find(params[:id])
  end

  # POST /tips
  # POST /tips.xml
  def create
    params[:tip][:user]=session[:user] if !session[:user].nil?
    @tip = Tip.new(params[:tip])

    respond_to do |format|
      if @tip.save
        format.html { redirect_to(@tip, :notice => 'Tip was successfully created.') }
        format.xml  { render :xml => @tip, :status => :created, :location => @tip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tips/1
  # PUT /tips/1.xml
  def update
    @tip = Tip.find(params[:id])

    respond_to do |format|
      # This will check to see if an update is occurring on a page that has already been updated
      if params[:updated_at] != @tip.updated_at.to_s
        flash[:error] = "This tip is stale, please save your changes, search for the tip again, and edit."
        @tip.title = params[:tip][:title]
        @tip.body = params[:tip][:body]
        format.html { render :action => :edit, @tip => @tip }
      elsif @tip.user==session[:user] && @tip.update_attributes(params[:tip])
        format.html { redirect_to(@tip, :notice => 'Tip was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.xml
  def destroy
    @tip = Tip.find(params[:id])
    # Tips can only be destroyed by the user who created them
    if @tip.user==session[:user]
      @tip.destroy
      flash[:notice] = "Tip destroyed."
    else
      flash[:error] = "Tips can only be deleted by the user who created them."
    end

    respond_to do |format|
      format.html { redirect_to(tips_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def authorize
    if session[:user].nil? || session[:user].empty?
      flash[:error] = "You must be logged in to complete this action."
      redirect_to tips_path
      return false
    end
  end
end
