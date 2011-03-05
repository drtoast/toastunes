class TracksController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    @album = Album.find(params[:album_id])
    @track = @album.tracks.create!(params[:track])
    redirect_to @album, :notice => "Track created"
  end
  
end
