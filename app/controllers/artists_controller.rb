class ArtistsController < ApplicationController

  respond_to :json

  def index
    #@letter = params[:letter] || "a"
    #@letter = '[^a-z]' if @letter == '-'
    #@artists = Artist.where(:name => /^#{@letter}/i).ascending(:name)
    @artists = Artist.all.ascending(:name)
    respond_with @artists
  end

end
