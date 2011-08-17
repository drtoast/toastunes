class AlbumsController < ApplicationController
  
  # GET /albums
  # GET /albums.xml
  def index

    if params[:letter]
      @letter = params[:letter]
      @letter = '[^a-z]' if @letter == '-'
      criteria = Album.all.ascending(:title).criteria.where(:title => /^#{@letter}/i)
    else
      criteria = Album.all.descending(:created_at)
      @limit = params['limit'] ? [params['limit'].to_i, 100].max : 50
      @skip = params['skip'] ? [params['skip'].to_i, @limit].max : 0
      criteria = criteria.limit(@limit).skip(@skip)
    end

    unless params['genre'].blank?
      criteria = criteria.where(:genre_id => params['genre'])
    end
    unless params['rating'].blank?
      criteria = criteria.where(:rating => params['rating'])
    end
    @albums = criteria
    @genres = sorted_genres # application_helper.rb
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])
    @new_comment = @album.comments.build
    @genres = sorted_genres # application_controller.rb
    @covers = session[:covers] && session[:covers][@album.id.to_s] ? session[:covers][@album.id.to_s] : []
    @error = nil
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])

    respond_to do |format|
      if @album.save
        format.html { redirect_to(@album, :notice => 'Album was successfully created.') }
        format.xml  { render :xml => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
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
    respond_to do |format|
      
      @album.genre = Genre.find(params[:genre])
      if @album.save
        @msg = "genre changed to #{@album.genre.name}"
        format.js { render :layout => false }
      end
    end
  end

  # ajax upload
  def upload_cover
    @album = Album.find(params[:id])
    respond_to do |format|
      
      # TODO: cover doesn't upload when form submitted asynchronously - would need to use an iframe to do that
      @album.cover = nil
      file = params[:file]
      ext = File.extname(file.original_filename)[1..-1]
      @album.add_cover(file.path, ext, false) # TODO: fix segfault when processing thumbnail in mongrel
      logger.info "*** FILE: #{file.original_filename}, #{file.path}, #{file.inspect}"
      if @album.save
        # TODO: ajax upload doesn't work
        format.js { render :layout => false }
        format.html { redirect_to album_path(@album)}
      end
    end
  end
  
  # get cover from amazon
  def amazon_cover
    
    @album = Album.find(params[:id])
    
    aaws = AAWS::Music.new
    @covers = aaws.covers(:query => {:artist => @album.artist.name, :keywords => @album.title})
    @album.cover_download_at = Time.now
    if @covers.length > 0
      session[:covers] = {@album.id.to_s => @covers}
      best = @covers.detect{|c| c[:large]}
      if best
        @album.download_cover(best[:large])
        @album.download_thumbnail(best[:small])
        # @album.save_thumbnail
      end
    else
      @error = aaws.error
    end
    @album.save
    
    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to album_path(@album)}
    end
    
  end

  def choose_amazon_cover
    
    @album = Album.find(params[:id])
    @covers = session[:covers][@album.id.to_s]
    chosen = @covers[params[:index].to_i]
    @album.download_cover(chosen[:large])
    @album.download_thumbnail(chosen[:small])
    @album.save
    
    respond_to do |format|
      format.js { render :action => :amazon_cover, :layout => false }
      format.html { redirect_to album_path(@album)}
    end
    
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    deleted_files = 0
    deleted_album = @album.title
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url, :notice => "Deleted #{deleted_album}") }
      format.xml  { head :ok }
    end
  end
end
