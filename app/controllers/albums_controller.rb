class AlbumsController < ApplicationController

  respond_to :html, :json

  def index
    respond_to do |format|
      format.html do
        # boostrap: most recent albums
        @albums = Album.order_by([:created_at, :desc]).limit(100)
        @artists = Artist.all.order_by([:name, :asc])
      end

      format.json do
        # lazily load: select via params
        respond_with(@albums = Album.all)
      end
    end
  end
end
