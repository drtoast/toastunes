class Toastunes::DirectoryProcessor
  
  # p = Toastunes::DirectoryProcessor.new :library => 'w2', :root => '/path/to/library'
  # p = Toastunes::DirectoryProcessor.new :library => 'w2', :artist_path => '/path/to/library/artist'
  # p = Toastunes::DirectoryProcessor.new :library => 'w2', :album_path => '/path/to/library/artist/album'
  # p.process!
  def initialize(opts={})
    @options = opts # HashWithIndifferentAccess when from controller
    @options[:set_artist]      ||= true
    @options[:set_genre]       ||= true
    @options[:process_cover]   ||= true
    @options[:archive_tracks]  ||= true
  end
  
  # parse a directory of artist directories,
  # where directory structure is like:
  # #{Rails.root}/public/music/#{library}/Some Artist/Some Album/01 Some Track.mp3
  def process!
    if @options[:root]
      root = @options[:root] # File.join(Rails.root, 'public', 'music', @options[:library])
      Dir.entries(root).reject{|a| a.match /^\./}.each do |subdir|
        artist_path = File.join(root, subdir)
        next unless File.directory? artist_path
        process_artist artist_path
      end
    elsif @options[:artist_path]
      process_artist @options[:artist_path]
    elsif @options[:album_path]
      # TODO:
      # artist_name = ???
      # album_title = ???
      # process_album @options[:album], artist_name, album_title
    end
  end
  
  # parse a hierarchy structured like this:
  # /path/to/Artist/Album/01.mp3
  def process_artist(artist_dir)
    artist_name = File.basename(artist_dir)
    albums = Dir.entries(artist_dir).reject{|a| a.match /^\./}
    albums.each do |album_title|
      album_path = File.join(artist_dir, album_title)
      if File.directory? album_path
        begin
          process_album album_path, artist_name, album_title
        rescue Toastunes::AlbumProcessor::DirectoryEmptyError => e # Exception => e
          #raise e
          puts "DirectoryProcessor#process_artist: #{e.inspect}"
        end
      end
    end
  end

  def process_album(album_path, artist_name, album_title)
    opts = @options.merge(
      :artist_name => artist_name,
      :album_title => album_title,
      :album_path =>  album_path
    )
    processor = Toastunes::AlbumProcessor.new opts
    processor.process!
  end

end