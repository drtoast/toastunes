# http://www.guydavis.ca/log/view.jsp?id=973
require 'rexml/streamlistener'
require 'rexml/document'

class Toastunes::TunesParser 
  include REXML::StreamListener

  attr_reader :parsing_key, :value_type, :key, :value

  # '/Users/toast/Desktop/itml.xml'
  def self.parse!
    REXML::Document.parse_stream(File.open(Toastunes::Application.config.itunes_library), self.new)
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
      @dict["Location"] = @value.sub(/#{Toastunes::Application.config.itunes_base}/, '')
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
      album.library = 'itunes'
      
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
