class AlbumsController < ApplicationController

  respond_to :html, :json

  def index
    respond_with(@albums = Album.all)
  end

end
