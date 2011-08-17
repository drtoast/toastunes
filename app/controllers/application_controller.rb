class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  def sorted_genres
    Genre.all.ascending(:name)#sort{|a,b| a.name.to_s.downcase <=> b.name.to_s.downcase}
  end

end
