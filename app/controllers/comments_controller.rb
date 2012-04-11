class CommentsController < ApplicationController

  respond_to :json

  def index
    respond_to do |format|
      format.json do
        # lazily load: select via params
        respond_with(@albums = Album.all)
      end
    end
  end
end
