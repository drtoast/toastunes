class Api::V1::RatingsController < ApplicationController

  respond_to :json

  def index
    @ratings = Rating.where(:album_id => params[:album_id])
    respond_with @ratings, :location => api_v1_ratings_url
  end

  def create
    @rating = Rating.new(
        album_id: params[:album_id],
        rating:   params[:rating],
        user:     current_user)

    if @rating.save
      respond_with @rating, :location => api_v1_ratings_url
    else
      respond_with @rating, :status => :unprocessable_entity
    end
  end
end
