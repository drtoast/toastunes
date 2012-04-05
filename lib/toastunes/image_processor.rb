class Toastunes::ImageProcessor
  
  # copy the original image to the appropriate location according to format and album_id
  def save_cover(cover_dir, album_id, original, format=nil)
    format ||= File.extname(original)[1..-1]
    #path = File.join(album.cover_dir, "#{album.id}.#{format}")
    path = File.join(cover_dir, "#{album_id}.#{format}")
    FileUtils.mkdir_p File.dirname(path)
    FileUtils.copy(original, path)
    return path
  end
  
  # given an album_id, file format, and raw image data, write the full cover
  def write_full_data(cover_dir, album_id, format, data)
    #path = File.join(album.cover_dir, "#{album.id}.#{format}")
    path = File.join(cover_dir, "#{album_id}.#{format}")
    FileUtils.mkdir_p File.dirname(path)
    File.open(path, "w") do |f|
      f.syswrite data
    end
    return path
  end
  
  # given an album_id and the path to the full image, write the thumbnail
  def write_thumbnail(thumbnail_dir, album_id, full_path)
    img = Magick::ImageList.new(full_path)
    t = img.thumbnail(75, 75)
    #path = File.join(album.thumbnail_dir, "#{album.id}.png")
    path = File.join(thumbnail_dir, "#{album_id}.png")
    FileUtils.mkdir_p File.dirname(path)
    t.write(path)
    return path
  end

end