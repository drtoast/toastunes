class Toastunes::ImageProcessor
  
  # copy the original image to the appropriate location according to format and album_id
  def save_cover(album_id, original, format=nil)
    format ||= File.extname(original)[1..-1]
    path = full_path(album_id, format)
    FileUtils.copy(original, path)
    return path
  end
  
  # given an album_id, file format, and raw image data, write the full cover
  def write_full_data(album_id, format, data)
    path = full_path(album_id, format)
    File.open(path, "w") do |f|
      f.syswrite data
    end
    return path
  end
  
  # given an album_id and the path to the full image, write the thumbnail
  def write_thumbnail(album_id, large_path)
    img = Magick::ImageList.new(large_path)
    t = img.thumbnail(75, 75)
    path = thumbnail_path(album_id)
    t.write(path)
    return path
  end
  
  def full_path(album_id, format)
    File.join(Rails.root, 'public', 'images', 'covers', "#{album_id}.#{format}")
  end

private


  
  def thumbnail_path(album_id)
    File.join(Rails.root, 'public', 'images', 'thumbnails', "#{album_id}.png")
  end
  
end