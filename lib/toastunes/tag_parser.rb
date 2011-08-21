require 'mp3info'

=begin

image formats:
  png signature starts with ["89", "50", "4e", "47", "d", "a", "1a", "a"]
  jpg signature starts with ["FF", "E0"]

id3v2.2:
  http://www.id3.org/id3v2-00
  3-char tags, e.g. i.tag2.keys => ["TT2", "TRK", "TP1", "TAL", "TCO", "PIC"]
  Attached picture   "PIC"
  Frame size         $xx xx xx
  Text encoding      $xx
  Image format       $xx xx xx
  Picture type       $xx
  Description        <textstring> $00 (00)
  Picture data       <binary data>
  tag2.PIC => "\x00PNG0\x00\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x01,\x00\x00\x01\x04\b\x02\x00\x00\x00\x1D\xE0\x9Ey\x00\x00\x00\x04gAMA\x00\x00\xD9\x03B\xD6O\xA1\x00\x00\x00\tpHYs\x00\x00\v\x13\x00\x00\v\x13\x01\x00\x9A\x9C\x18\x00\x00\x00\"tEXtSoftware\x00QuickTime 6.5 (Mac OS X)\x00:s\xC5;\x00\x00\x00

id3v2.3:
  http://www.id3.org/id3v2.3.0
  4-char tags, e.g. i.tag2.keys => ["TALB", "COMM", "TIT2", "TPE1", "TYER", "TRCK", "APIC"]
  <Header for 'Attached picture', ID: "APIC"> 
  Text encoding   $xx
  MIME type       <text string> $00
  Picture type    $xx
  Description     <text string according to encoding> $00 (00)
  Picture data    <binary data>
  text_encoding, mime_type, picture_type, description, data = pic.split(/\x00/, 5)
  tag2.APIC => "\x00image/jpeg\x00\x00\x00\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00\xFF\xFE\x00;CREATOR: gd-jpeg v1.0 (using IJG JPEG v62)

=end

class Toastunes::TagParser
  
  IMAGE_FORMATS = {
    
    # >= id3v2.3
    'image/jpeg' => 'jpg',
    'image/jpg' => 'jpg',
    'image/png' => 'png',
    
    # id3v2.2
    'PNG' => 'png',
    'JPG' => 'jpg'
  }
  
  attr_reader :info
  
  def initialize(path)
    parse path
  end
  
  def parse(path)
    @info = Mp3Info.new(path)
    # if @info.hastag2?
    #   puts "parse_tag: #{@info.tag2.version}"
    # end
    # if @info.tag
    #   title = i.tag.title
    #   artist = i.tag.artist
    #   album = i.tag.album
    #   track = i.tag.tracknum
    #   genre = i.tag.genre_s
    # end
  end
  
  def sanitize(str)
    # or: str.encode("ISO-8859-1", "UTF-8", {:invalid => :replace, :undef => :replace, :replace => "?"})
    return nil unless str
    str = str.to_s unless str.is_a?(String)
    unless str.encoding.name == "UTF-8"
      # "ASCII-8BIT" should be "ISO-8859-1" - see Amélie (4d63689bca990a3dfb0003f9)
      str.force_encoding("ISO-8859-1")
    end
    str.encode("UTF-8", {:invalid => :replace, :undef => :replace, :replace => "?"})
  end
  
  def title
    sanitize @info.tag.title
  end
  
  def artist
    sanitize @info.tag.artist
  end
  
  def album
    sanitize @info.tag.artist
  end
  
  def track_number
    sanitize @info.tag.tracknum
  end
  
  def genre
    sanitize @info.tag.genre_s
  end
  
  def year
    sanitize @info.tag.year
  end
  
  def extract_cover(album)
    if @info.hastag2?
      # GET PICTURE

      if @info.tag2.version.match(/^2\.2\./)
        if pic = @info.tag2.PIC
          text_encoding = pic[0]
          image_format = pic[1,3]
          raise "image format not recognized: #{image_format}" unless IMAGE_FORMATS[image_format]
          picture_type = pic[4]
          description, data = pic[5..-1].split(/\x00/, 2)
          full_path = write_image(album, IMAGE_FORMATS[image_format] || image_format, data)
        end
      else
        if pic = @info.tag2.APIC
          pic = Array(pic).first # grab the first if there are multiple images
          begin
            text_encoding = pic[0]
            mime_type, pic = pic[1..-1].split(/\x00/, 2)
            picture_type = pic[0]
            description, data = pic[1..-1].split(/\x00/, 2)
            raise "mime type not recognized: #{image_format}" unless IMAGE_FORMATS[mime_type]
            full_path = write_image(album, IMAGE_FORMATS[mime_type] || mime_type, data)
          rescue => e
            puts "ERROR parsing tag2.APIC: #{e.inspect}"
            return nil
          end
        end
      end
      # puts "TEXT ENCODING: #{text_encoding}"
      # puts "IMAGE FORMAT: #{image_format}"
      # puts "MIME TYPE: #{mime_type}"
      # puts "PICTURE TYPE: #{picture_type}"
      # puts "DESCRIPTION: #{description}"
      # puts "DATA: #{data.length} bytes"
      # puts "#{data[0,20].to_s}"
      return full_path
    else
      return nil
    end # hastag2?
  rescue Exception => e
    puts "WARNING: can't extract cover: '#{e.inspect}"
    return nil
  end
  
  def write_image(album, format, data)
    processor = Toastunes::ImageProcessor.new
    # save cover
    full_path = processor.write_full_data(album, format, data)
    # save thumbnail
    processor.write_thumbnail(album, full_path)
    return full_path
  end
  
  def get_tag(path)
    Mp3Info.open(path)
  end
  
end