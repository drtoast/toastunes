class TracksController < ApplicationController
  
  def create
    @album = Album.find(params[:album_id])
    @track = @album.tracks.create!(params[:track])
    redirect_to @album, :notice => "Track created"
  end
  
end
