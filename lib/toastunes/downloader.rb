class Toastunes::Downloader

  attr_accessor :zip_file, :extract_to, :file_id, :parser, :album

  def initialize(options)
    @options     = options
    @url         = options[:url]
    @artist_name = options[:artist_name]
    @album_title = options[:title]
    @compilation = options[:compilation]
    @user        = options[:user]
    @library     = options[:library]

    raise "artist_name is required" if @artist_name.blank?
    raise "url is required" if @url.blank?
    raise "title is required" if @album_title.blank?
  end

  def run!
    download_zip
    extract_zip
    process_tracks
    process_cover
    archive_tracks
  end

  def download_zip
    @file_id    = (Time.now.to_f * 1000.0).to_i
    @zip_file   = "/tmp/#{file_id}.zip"
    @extract_to = "/tmp/#{file_id}"
    run_command "curl '#{URI.parse(@url)}' -o '#{zip_file}'"
  end

  def extract_zip
    if File.exists? @zip_file
      FileUtils.mkdir @extract_to unless File.exists?(@extract_to)
      run_command "unzip -j '#{@zip_file}' -d '#{@extract_to}'"
    end
  end

  # find or create an album via the downloaded files
  def process_tracks
    @album = parser.parse_album(@extract_to, @artist_name, @album_title)
  end

  # extract the cover and thumbnail from the first track
  def process_cover
    puts "LIBRARY: #{@options[:library]}"
    tag_parser = Toastunes::TagParser.new(files.first)
    cover_path = tag_parser.extract_cover(@album.cover_dir, @album.thumbnail_dir, @album.id)
    if cover_path
      @album.cover = File.basename(cover_path)
      @album.thumbnail = "#{@album.id}.png"
      @album.save
    end
  end

  # move the tracks from the tmp dir to the music archive
  def archive_tracks
    archive_dir = File.join(Rails.root, 'public', 'music', @library, @artist_name, @album_title)
    puts archive_dir
    FileUtils.mkdir_p archive_dir
    files.each do |file|
      basename = File.basename(file)
      FileUtils.mv(file, File.join(archive_dir, basename))
    end
  end


private

  # return a cached instance of a DirectoryParser
  def parser
    @parser ||= Toastunes::DirectoryParser.new(@options)
  end

  # return an array of paths to valid music files in the directory
  def files
    Dir.entries(@extract_to)
      .grep(/\.(mp3|m4a)$/)
      .reject{|f| f =~ /^\./}
      .map{|f| "#{@extract_to}/#{f}"}
  end

  # run the given shell command
  def run_command(cmd)
    puts cmd
    result = `#{cmd} 2>&1`
    puts result
    raise result unless $?.success?
  end

  def self.test
    d = Toastunes::Downloader.new(
        :library => 'w2',
        :user => User.last,
        :url => 'http://dl.dropbox.com/u/966739/abbeyroad.zip',
        :artist_name => 'The Beatles',
        :title => 'Abbey Road'
    )
    d.run!
    #d.extract_to = '/tmp/1329955403629'
    #d.process_tracks
    #d.process_cover
    #d.archive_tracks
    true
  end

end
