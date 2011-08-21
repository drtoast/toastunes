class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # fields
  field :title, :type => String
  field :artist_name, :type => String # can't use "artist" due to association
  field :compilation, :type => Boolean
  field :cover, :type => String
  field :thumbnail, :type => String
  field :rating, :type => Integer # 0 to 100
  field :genre, :type => String
  field :library, :type => String # where does this album's files live?
  field :cover_download_at, :type => Time # when did we add an amazon cover?
  
  # indices
  index :created_at
  index :title
  index :rating

  # associations
  embeds_many :tracks
  references_many :comments
  references_many :ratings
  referenced_in :artist
  referenced_in :genre
  referenced_in :user
  
  # kind
  scope :compilation, :where => {:compilation => true}
  scope :aac, :where => {:kind => "AAC audio file"}
  scope :mp3, :where => {:kind => "MPEG audio file"}
  
  # sweetness
  scope :sweet, :where => {:rating.gt => 60}
  scope :okay, :where => {:rating => 60}
  scope :ugh, :where => {:rating.lte => 40}
  
  def process_album
    extract_cover
    set_artist
    set_genre
    save
  end
  
  before_destroy :delete_files
  
  # extract a cover from the ID3 tag
  def extract_cover(replace_cover=true)
    if cover && !replace_cover
      return false
    end
    return false if tracks.empty?
    if full_path = tracks.first.extract_cover
      self.cover = File.basename(full_path)
      self.thumbnail = "#{id}.png"
    end
  end
  
  # resize and attach the image at the raw path
  def add_cover(original, format=nil, thumb=true)
    processor = Toastunes::ImageProcessor.new
    full_path = processor.save_cover(id, original, format)
    self.cover = File.basename(full_path)
    if thumb
      thumbnail_path = processor.write_thumbnail(self)
      self.thumbnail = File.basename(thumbnail_path)
    end
  end
  
  def download_cover(url)
    format = File.extname(url)[1..-1]
    destination = File.join(cover_dir, "#{id}.#{format}")
    response = download(url, destination)
    if response.kind_of? Net::HTTPOK
      self.cover = File.basename(destination)
      # TODO: this segfaults when running in Mongrel
      # save_thumbnail
    end
  end
  
  def download_thumbnail(url)
    format = File.extname(url)[1..-1]
    destination = File.join(thumbnail_dir, "#{id}.#{format}")
    response = download(url, destination)
    if response.kind_of? Net::HTTPOK
      self.thumbnail = File.basename(destination)
    end
  end

  def save_thumbnail
    processor = Toastunes::ImageProcessor.new
    if cover_path
      thumb = processor.write_thumbnail(self)
      if thumb
        self.thumbnail = File.basename(thumb)
      end
    end
  end
  
  def cover_dir
    File.join(Rails.root, 'public', 'images', 'covers', library)
  end
  
  def thumbnail_dir
    File.join(Rails.root, 'public', 'images', 'thumbnails', library)
  end
  
  def cover_path
    if cover
      File.join(cover_dir, cover)
    else
      nil
    end
  end
  
  def thumbnail_path
    if thumbnail
      File.join(thumbnail_dir, cover)
    else
      nil
    end
  end
  
  def download(url, destination)
    uri = URI.parse(url)
    response = Net::HTTP.start(uri.host) do |http|
      response = http.get(uri.path)
      open(destination, "wb") do |file|
        file.write(response.body)
      end
      response
    end
  end
  
  def set_artist(name=nil)
    if name
      self.artist_name = name
    else
      # detect artist name via tracks
      artists = tracks.collect{|t| t.artist_name}.uniq
      if artists.length == 1
        begin
          self.artist_name = artists.first.to_s.blank? ? 'No Artist' : artists.first
        rescue => e
          self.artist_name = e.class.name
          puts "WARNING: #{e.inspect}"
        end
      else
        # puts "COMPILATION: #{artists.join(",")}"
        self.artist_name = 'Compilations'
      end
    end
    self.artist = Artist.where(:name => artist_name).first || Artist.create!(:name => artist_name)
  end
  
  def set_genre
    genres = tracks.collect{|t| t.genre}.uniq
    if genres.length == 1
      self.genre = Genre.where(:name => genres.first).first || Genre.create!(:name => genres.first)
    else
      self.genre = nil
    end
  end
  
  def closest_rating
    # need a rating quantized to 0,20,40,60,80 for form checkboxes
    (rating.to_i / 20) * 20
  end
  
private

  def delete_files
    tracks.each do |track|
      File.delete(track.local_path) if File.exists?(track.local_path)
    end
  end

end
