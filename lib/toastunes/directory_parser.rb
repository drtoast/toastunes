class Toastunes::DirectoryParser
  
  # p = Toastunes::DirectoryParser.new(:library => 'w2')
  # p.parse!
  def initialize(options={})
    @options = {
      :replace_artists => true,
      :replace_tracks => true,
      :replace_genres => true,
      :replace_covers => true
    }.merge(options)
  end
  
  # parse a directory of artist directories,
  # where directory structure is like:
  # #{Rails.root}/public/music/#{library}/Some Artist/Some Album/01 Some Track.mp3
  def parse!
    dir = File.join(Rails.root, 'public', 'music', @options[:library])
    Dir.entries(dir).reject{|a| a.match /^\./}.each do |subdir|
      d = File.join(dir, subdir)
      next unless File.directory? d
      parse_artist d
    end
  end
  
  # parse a hierarchy structured like this:
  # /path/to/Artist/Album/01.mp3
  def parse_artist(artist_dir)
    artist_name = File.basename(artist_dir)
    albums = Dir.entries(artist_dir).reject{|a| a.match /^\./}
    albums.each do |album_title|
      if File.directory?(File.join(artist_dir, album_title))
        parse_album(File.join(artist_dir, album_title), artist_name, album_title)
      end
    end
  end
  

  def parse_album(album_dir, artist_name, album_title)
    puts [Time.now, artist_name, album_title].join("\t")
    album = find_album(artist_name, album_title)
    album.library = @options[:library]
    
    # parse tracks
    Dir.entries(album_dir).reject{|a| a.match /^\./}.grep(/\.(mp3|m4a)$/).each do |file|
      
      location  = File.join(artist_name, album_title, file)
      track     = album.tracks.detect{|t| t.location == location}
      next if track and !@options[:replace_tracks]
      filename  = parse_filename(file)
      
      begin
        parser    = Toastunes::TagParser.new(File.join(album_dir, file))
         values = {
           :title =>       parser.title || filename[:track_title],
           :location =>    location,
           :created_at =>  Time.now,
           :track =>       parser.track_number || filename[:track_number],
           :genre =>       parser.genre,
           :artist_name => parser.artist || artist_name,
           :kind =>        filename[:kind],
           :year =>        parser.year,
        #   :size =>        file_size,
        #   :duration =>    duration,
        #   :bit_rate =>    bit_rate,
        #   :sample_rate => sample_rate,
        #   :itunes_pid =>  pid
         }
      rescue => e
        puts "WARNING: #{e.inspect}"
        values = {
           :title =>       filename[:track_title],
           :location =>    location,
           :created_at =>  Time.now,
           :track =>       filename[:track_number],
           :artist_name => artist_name,
           :kind =>        filename[:kind],
         }
      end
      add_track(album, values)
    end
    
    ## SAVE
    return if album.artist and !@options[:replace_artists]
    album.set_artist(artist_name)
    album.extract_cover(@options[:replace_covers]) # don't process if we already have a cover
    album.set_genre
    # album.genre = nil
    album.save
  rescue SignalException => e
    raise e
  rescue Exception => e
    puts "WARNING: #{e.inspect}"
  end
  
private
  
  
  # find or initialize an album with the given info
  def find_album(artist_name, album_title)
    compilation = (album_title == 'Compilation')
    # is this a compilation?
    if compilation
      h = {:title => album_title, :compilation => true}
    else
      h = {:title => album_title, :artist_name => artist_name}
    end
    # find or initialize album
    album = Album.where(h).first || Album.new(h)
    album.compilation = compilation
    album
  end
  
  
  # what info can we glean from the filename?
  def parse_filename(file)
    filename = {}
    if file.match(/^(\d{1,2}\s+)?(.*)\.(mp3|m4a)$/i)
      filename[:track_number] = $1.strip if $1
      filename[:track_title] = $2
      filename[:kind] = $3
    end
    filename
  end
  
  
  # update the track with the same location, or add a new one
  def add_track(album, values)
    if track = album.tracks.detect{|t| t.location == values[:location]}
      track.update_attributes(values)
    else
      album.tracks.create!(values)
    end
  end
  
  
end