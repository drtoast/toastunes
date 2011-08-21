module ApplicationHelper
  
  def display_user_name(user)
    link_to(user.name.blank? ? user.email : user.name, user)
  end
  
  def thumbnail_tag(album)
    link_to(image_tag(album && album.thumbnail ? "/images/thumbnails/#{album.library}/#{album.thumbnail}" : "no_cover.jpg", :class => 'thumbnail shadow', :title => (album && "#{album.artist_name} - #{album.title}")), album)
  end
  
  def cover_path(album)
    album && album.cover ? "/images/covers/#{album.library}/#{album.cover}" : "no_cover.jpg"
  end
  
end
