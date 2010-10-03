class Toast::Tunes

  require 'appscript'
  
  FORMATS = {
    "PNG " => 'png',
    :JPEG_picture => 'jpg'
  }
  
  def self.export_artwork(destination='/users/toast/code/ttunes/public/images')
    i = Toast::Tunes.new
    i.library_tracks do |track|
      i.export_artwork(track, destination)
    end
  end
  
  def initialize
    @itunes = Appscript.app('iTunes')
  end
  
  def library
    @itunes.sources.get.detect{|s| s.kind.get == :library}
  end
  
  def playlist_tracks(name,&block)
    tracks = library.user_playlists.get.detect{|p| p.name.get == name}.file_tracks.get
  end
  
  def export_artwork(track, destination)
    artworks = track.artworks.get
    if artworks.length > 0
      artwork = artworks[0]
      format = artwork.format.get
      format = format.code unless format.is_a?(Symbol)
      if ext = FORMATS[format]
        artist = track.artist.get
        album = track.album.get
        compilation = track.compilation.get
        artist = 'Compilations' if compilation
        filename = [artist, album].map{|s| s.downcase.gsub(/[^0-9a-z]/, '')}.join("_")
        path = File.join(destination, 'large', filename + ".#{ext}")
        if File.exists?(path)
          puts "EXISTS: #{path}"
          return
        else
          puts path
          raw_data = artwork.raw_data.get.data
          File.open(path, "w") do |f|
            f << raw_data
          end
        end
      else
        die "ERROR: format not recognized: #{format}"
      end
      
    end
  end
  
  def library_tracks(&block)
    library.library_playlists.get.detect{|p| p.name.get == 'Library'}.file_tracks.get.each do |track|
      yield track
    end
  end
  
  def show_all_tracks
    all_tracks do |t|
      title = t.name.get
      artist = t.artist.get
      album = t.album.get
      track_number = t.track_number.get
      compilation = t.compilation.get
      location = t.location.get.to_s
    end
  end
  
  private

end
