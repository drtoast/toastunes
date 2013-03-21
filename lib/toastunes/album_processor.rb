class Toastunes::AlbumProcessor

  attr_accessor :zip_file, :album_path, :extract_to, :file_id, :parser, :album

  def initialize(options)
    @options     = options
    @url         = options[:url]
    @album_path  = options[:album_path]
    @artist_name = options[:artist_name]
    @album_title = options[:album_title]
    @compilation = options[:compilation]
    @user        = options[:user]
    @library     = options[:library]

    @options[:set_artist]      ||= true
    @options[:set_genre]       ||= true
    @options[:archive_tracks]  ||= true
    @options[:process_cover]   ||= true

    raise "library is required" if @library.blank?
    raise "artist_name is required" if @artist_name.blank?
    #raise "url is required" if @url.blank?
    raise "album_title is required" if @album_title.blank?
  end

  def process!
    download_zip    if @url
    extract_zip     if @url
    find_album
    process_tracks
    set_artist      if @options[:set_artist]
    set_genre       if @options[:set_genre]
    process_cover   if @options[:process_cover]
    archive_tracks  if @options[:archive_tracks]
    @album.save
  end


  def download_zip
    @file_id    = (Time.now.to_f * 1000.0).to_i
    @zip_file   = "/tmp/#{file_id}.zip"
    @album_path = "/tmp/#{file_id}"
    run_command "curl '#{URI.parse(@url)}' -o '#{zip_file}'"
  end


  def extract_zip
    if File.exists? @zip_file
      FileUtils.mkdir @album_path unless File.exists?(@album_path)
      run_command "unzip -j '#{@zip_file}' -d '#{@album_path}'"
    end
  end


  def find_album
    puts [Time.now, @artist_name, @album_title].join("\t")
    # is this a compilation?
    search = {:title => @album_title}
    if compilation = (@album_title == 'Compilation')
      search[:compilation] = true
    else
      search[:artist_name] = @artist_name
    end

    # find or initialize album
    @album = Album.where(search).first || Album.new(search)
    @album.compilation = compilation
    @album.library = @options[:library]
    @album.user = @options[:user] if @options[:user]
    @album.save!
  end


  # find or create an album via the downloaded files
  def process_tracks
    raise DirectoryEmptyError.new('Directory empty') unless files.length > 0
    files.each do |file_path|
      filename  = parse_filename(file_path)

      begin
        parser    = Toastunes::TagParser.new(file_path)
        values = {
          :title =>       parser.title || filename[:track_title],
          :location =>    file_path,
          :created_at =>  Time.now,
          :track =>       parser.track_number || filename[:track_number],
          :genre =>       parser.genre,
          :artist_name => parser.artist || @artist_name,
          :kind =>        filename[:kind],
          :year =>        parser.year,
          #   :size =>        file_size,
          #   :duration =>    duration,
          #   :bit_rate =>    bit_rate,
          #   :sample_rate => sample_rate,
          #   :itunes_pid =>  pid
        }
      rescue => e
        puts "AlbumProcessor#process_tracks: #{e.inspect}"
        values = {
           :title =>       filename[:track_title],
           :location =>    file_path,
           :created_at =>  Time.now,
           :track =>       filename[:track_number],
           :artist_name => @artist_name,
           :kind =>        filename[:kind],
         }
      end
      add_track(album, values)
    end
  end


  # update the track with the same location, or add a new one
  def add_track(album, values)
    if track = @album.tracks.detect{|t| t.location == values[:location]}
      track.update_attributes(values)
    else
      @album.tracks.create!(values)
    end
  end


  def set_artist
    if @artist_name
      @album.artist_name = @artist_name
    else
      # detect artist name via tracks
      artists = @album.tracks.collect{|t| t.artist_name}.uniq
      if artists.length == 1
        begin
          @album.artist_name = artists.first.to_s.blank? ? 'No Artist' : artists.first
        rescue => e
          @album.artist_name = e.class.name
          puts "AlbumProcessor#set_artist: #{e.inspect}"
        end
      else
        # puts "COMPILATION: #{artists.join(",")}"
        @album.artist_name = 'Compilations'
      end
    end
    @album.artist = Artist.where(:name => @artist_name).first || Artist.create!(:name => @artist_name)
  end


  def set_genre
    genres = @album.tracks.collect{|t| t.genre}.uniq
    if genres.length == 1
      @album.genre = Genre.where(:name => genres.first).first || Genre.create!(:name => genres.first)
    else
      @album.genre = unclassified
    end
  end


  # extract the cover and thumbnail from the first track
  def process_cover
    tag_parser = Toastunes::TagParser.new(files.first)
    cover_path = tag_parser.extract_cover(@album.cover_dir, @album.thumbnail_dir, @album.id)
    if cover_path
      @album.cover = File.basename(cover_path)
      @album.thumbnail = "#{@album.id}.png"
    end
  end


  # move the tracks from the tmp dir to the music archive
  def archive_tracks
    archive_dir = File.join(Rails.root, 'public', 'music', @library, @artist_name, @album_title)
    FileUtils.mkdir_p archive_dir
    @album.tracks.each do |track|
      basename = File.basename(track.location)
      dest = File.join(archive_dir, basename)
      unless track.location == dest
        FileUtils.mv(track.location, dest)
        track.location = dest
      end
    end
  end


  # what info can we glean from the filename?
  def parse_filename(file)
    filename = {}
    File.basename(file).match(/^(\d{1,2}\s+)?(.*)\.(.{3,4})$/i)
    filename[:track_number] = $1.strip if $1
    filename[:track_title] = $2
    filename[:kind] = $3.downcase
    filename
  end

private


  # return a cached instance of a DirectoryProcessor
  def parser
    @parser ||= Toastunes::DirectoryProcessor.new(@options)
  end


  # return an array of paths to valid music files in the directory
  def files
    Dir.entries(@album_path)
      .grep(/\.(mp3|m4a)$/)
      .reject{|f| f =~ /^\./}
      .map{|f| "#{@album_path}/#{f}"}
  end


  # run the given shell command
  def run_command(cmd)
    puts cmd
    result = `#{cmd} 2>&1`
    puts result
    raise result unless $?.success?
  end

  def unclassified
    @unclassified ||= (Genre.where(:name => 'Unclassified').first || Genre.create!(:name => 'Unclassified'))
  end

  class DirectoryEmptyError < StandardError; end;

end
