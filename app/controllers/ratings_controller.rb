class RatingsController < ApplicationController

  def index
    @ratings = Rating.all.desc(:created_at)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ratings }
    end
  end
  
end
