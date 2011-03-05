module AlbumsHelper
  
  RATINGS = {
    nil => 'nostar',
    0 => 'nostar',
    20 => 'onestar',
    40 => 'twostar',
    60 => 'threestar',
    80 => 'fourstar',
    100 => 'fivestar'
  }
  
  def album_rating_class(album)
    RATINGS[album.rating]
  end
  
end
