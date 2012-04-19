class CommentsController < ApplicationController

  respond_to :json

  def index
    respond_to do |format|
      format.json do
        respond_with(@comments = Comment.where(:album_id => params[:album_id]))
      end
    end
  end
end
