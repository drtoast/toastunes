class AlbumsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def show
    @album = Album.find params[:id]
    #respond_to do |format|
    #  format.json do
    #    render 'albums/show'
    #  end
    #end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    options = params[:album].merge({ :library => 'w2', :url => params[:download_link] })
    downloader = Toastunes::Downloader.new(options)
    downloader.run!
    redirect_to(downloader.album, :notice => "Album was successfully created")
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to(@album, :notice => 'Album was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # ajax star rating
  def rate
    @album = Album.find(params[:id])
    @rating = @album.ratings.where(:user_id => current_user.id).first
    if @rating
      @rating.rating = params[:rating].to_i
      @rating.save
    else
      @rating = Rating.new(:user => current_user, :rating => params[:rating].to_i)
      @album.ratings << @rating
    end
    respond_to do |format|
      avg = @album.ratings.map{|r| r.rating}.inject{ |sum, el| sum + el }.to_f / @album.ratings.size
      @album.rating = avg.to_i
      if @album.save
        format.js { render :layout => false }
      end
    end
  end

  # ajax genre
  def genre
    @album = Album.find(params[:id])

  def index
    respond_to do |format|
      format.html do
        # bootstrap: most recent albums
        @albums = Album.order_by([:created_at, :desc]).limit(20)
        @artists = Artist.order_by([:name, :asc])
        @comments = Comment.order_by([:created_at, :desc]).limit(50)
        @ratings = Rating.order_by([:created_at, :desc]).limit(50)
        @users = User.order_by([:name, :asc]).limit(100)
        @user = current_user
      end

      format.json do
        @albums = Album.all
        # lazily load: select via params
        # respond_with(@albums = Album.where(:artist_id => params[:artist_id]))
      end
    end
  end
end
