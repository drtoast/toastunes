# http://guides.rubyonrails.org/caching_with_rails.html

class ArtistSweeper < ActionController::Caching::Sweeper
  observe Artist
 
  def after_create(artist)
    expire_cache_for(artist)
  end
 
  def after_update(artist)
    expire_cache_for(artist)
  end
 
  def after_destroy(artist)
    expire_cache_for(artist)
  end
 
  private
  def expire_cache_for(artist)
    # Expire the index page now that we added a new product
    expire_page(:controller => 'artists', :action => 'index')
 
    # Expire a fragment
    expire_fragment('all_available_products')
  end
end