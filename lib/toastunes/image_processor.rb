class Toastunes::ImageProcessor
  
  # copy the original image to the appropriate location according to format and album_id
  def save_cover(album, original, format=nil)
    format ||= File.extname(original)[1..-1]
    path = File.join(album.cover_dir, "#{album.id}.#{format}")
    FileUtils.copy(original, path)
    return path
  end
  
  # given an album_id, file format, and raw image data, write the full cover
  def write_full_data(album, format, data)
    path = File.join(album.cover_dir, "#{album.id}.#{format}")
    File.open(path, "w") do |f|
      f.syswrite data
    end
    return path
  end
  
  # given an album_id and the path to the full image, write the thumbnail
  def write_thumbnail(album, full_path)
    img = Magick::ImageList.new(full_path)
    t = img.thumbnail(75, 75)
    path = File.join(album.thumbnail_dir, "#{album.id}.png")
    t.write(path)
    return path
  end

end