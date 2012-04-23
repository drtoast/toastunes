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

  def index
    respond_to do |format|
      format.html do
        # bootstrap: most recent albums
        @albums = Album.order_by([:created_at, :desc]).limit(20)
        @artists = Artist.order_by([:name, :asc])
        @comments = Comment.order_by([:created_at, :desc]).limit(50)
        @ratings = Rating.order_by([:created_at, :desc]).limit(50)
        @users = User.order_by([:name, :asc]).limit(100)
      end

      format.json do
        @albums = Album.all
        # lazily load: select via params
        # respond_with(@albums = Album.where(:artist_id => params[:artist_id]))
      end
    end
  end
end
