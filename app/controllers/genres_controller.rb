class GenresController < ApplicationController
  
  def index
    @genres = Genre.all.sort{|a,b| a.name.to_s.downcase <=> b.name.to_s.downcase}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genres }
    end
  end
  
end
