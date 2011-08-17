class CommentsController < ApplicationController

  def index
    @comments = Comment.all.desc(:created_at)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  
  # ajax comment
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.album_id = params[:album_id]
    
    respond_to do |format|
      if @comment.save
        # TODO: fixme
        format.js { render :layout => false }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    logger.info "USER: #{@comment.user.id}"
    logger.info "CURRENT USER: #{current_user.id}"
    @comment_id = params[:id]
    if @comment.user == current_user
      @comment_id = params[:id]
      @comment.destroy
    else
      # TODO: error messaging
    end
    
    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
      format.js { render :layout => false }
    end
  end
  
end
