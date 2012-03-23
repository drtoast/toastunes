# http://www.guydavis.ca/log/view.jsp?id=973
require 'rexml/streamlistener'
require 'rexml/document'

class Toastunes::TunesParser 
  include REXML::StreamListener

  attr_reader :parsing_key, :value_type, :key, :value

  def self.parse!(path_to_itunes, library_name='itunes')
    # detect itunes music dir and library file, create symlink
    itunes_music_dir = Dir.entries(path_to_itunes).detect{|d| d.match(/iTunes [Media|Music]/)}
    itunes_library   = Dir.entries(path_to_itunes).detect{|d| d.match(/iTunes Music Library.xml/)}
    FileUtils.ln_s(File.join(path_to_itunes, itunes_music_dir), File.join(Rails.root, 'public', 'music', library_name))
    FileUtils.mkdir_p(File.join(Rails.root, 'assets', 'images', 'covers', library_name))
    FileUtils.mkdir_p(File.join(Rails.root, 'assets', 'images', 'thumbnails', library_name))
    
    # parse the library
    REXML::Document.parse_stream(File.open(File.join(path_to_itunes, itunes_library)), self.new(library_name))
  end
  
  def initialize(library_name)
    @library_name = library_name
  end
  
  def tag_start(name, attrs)
    if name == "key" 
      @parsing_key = true
    else
      @value_type = name
    end
  end

  def text(text)
    if @parsing_key 
      @key = text
    else
      @value = text
    end
  end

  def tag_end(name)
    if name == 'key'
      @parsing_key = false
    elsif @key == "Location"
      # skip unless audio
      return unless @dict["Kind"].match(/audio/i)
      
      # Location is the last tag, so process the track
      @dict["Location"] = @value.sub(/^.*iTunes%20Music\//, '')
      puts [@dict["Track ID"], @dict['Album'], @dict['Name']].join("\t")
      compilation = @dict.keys.include?('Compilation')
      
      ## ALBUM
      if compilation
        h = {:title => @dict['Album'], :compilation => true}
      else
        h = {:title => @dict['Album'], :artist_name => @dict['Artist']}
      end
      album = Album.where(h).first || Album.new(h)
      album.rating = @dict['Album Rating']
      album.compilation = compilation
      album.library = @library_name
      
      ## TRACK
      pid = @dict["Persistent ID"]
      values = {
        :title =>       @dict['Name'],
        :location =>    URI::unescape(@dict['Location']),
        :rating =>      @dict['Rating'],
        :created_at =>  @dict['Date Added'],
        :played_at =>   @dict['Play Date UTC'] ? Time.xmlschema(@dict['Play Date UTC']) : nil,
        :track =>       @dict['Track Number'],
        :track_count => @dict['Track Count'],
        :genre =>       @dict['Genre'],
        :artist_name => @dict['Artist'],
        :kind =>        @dict['Kind'],
        :size =>        @dict['Size'],
        :duration =>    @dict['Total Time'],
        :year =>        @dict['Year'],
        :bit_rate =>    @dict['Bit Rate'],
        :sample_rate => @dict['Sample Rate'],
        :itunes_pid =>  pid
      }
      if track = album.tracks.detect{|t| t.itunes_pid == pid}
        track.update_attributes(values)
      else
        album.tracks.create!(values)
      end
      
      ## SAVE
      album.save
      @dict = {}
      
    else
      @dict ||= {}
      @dict[@key] = @value
    end

  end
end
