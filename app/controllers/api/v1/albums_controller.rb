class Api::V1::AlbumsController < ApplicationController

  respond_to :json

  def index
    @albums = Album.where(:artist_id => params[:artist_id])
    respond_with @albums, :location => api_v1_albums_url
  end

  def create
    @album = Album.new(params[:album])
    @album.user = User.first # current_user

    if @album.save
      respond_with @album, :location => api_v1_albums_url
    else
      respond_with @album, :status => :unprocessable_entity
    end
  end
end
