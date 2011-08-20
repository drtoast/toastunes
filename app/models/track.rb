require 'cgi'

class Track
  include Mongoid::Document
  field :title, :type => String
  field :artist_name, :type => String
  field :duration, :type => Integer
  field :rating, :type => Integer
  field :kind, :type => String
  field :size, :type => Integer
  field :bit_rate, :type => Integer
  field :location, :type => String
  field :year, :type => Integer
  field :track, :type => Integer
  field :track_count, :type => Integer
  field :created_at, :type => Time
  field :played_at, :type => Time
  field :itunes_pid, :type => String
  field :bit_rate, :type => Integer
  field :sample_rate, :type => Integer
  
  embedded_in :album, :inverse_of => :tracks
  
  def local_path
    File.join(Rails.root, 'public', 'music', album.library, location)
  end
  
  def web_path
    File.join('/music', album.library, URI::escape(location))
  end

  def extract_cover
    begin
      id3.extract_cover(album)
    rescue Mp3InfoError => e
      puts "ERROR: couldn't parse #{local_path}: #{e.inspect}"
    end
  end
  
  # get track info via id3
  def id3
    @parser ||= Toastunes::TagParser.new(local_path)
  end
  
  # get track info via filename
  def parsed_filename
    @info ||= if File.basename(location).match(/^(\d{1,2}\s+)?(.*)\.(mp3|m4a)$/i)
      parsed = {}
      parsed[:track_number] = $1.strip if $1
      parsed[:track_title] = $2
      parsed[:kind] = $3
      parsed
    else
      {}
    end
  end
  
  def id3_title
    id3.title
  end
  
  def parsed_title
    parsed_filename[:track_title]
  end
  
  def id3_track
    id3.track
  end
  
  def parsed_track
    parsed_filename[:track_number]
  end
  

  
end
