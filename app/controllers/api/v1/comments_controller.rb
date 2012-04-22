class Api::V1::CommentsController < ApplicationController

  respond_to :json

  def index
    @comments = Comment.where(:album_id => params[:album_id])
    respond_with @comments, :location => api_v1_comments_url
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = User.first # current_user

    if @comment.save
      respond_with @comment, :location => api_v1_comments_url
    else
      respond_with @comment, :status => :unprocessable_entity
    end
  end
end
