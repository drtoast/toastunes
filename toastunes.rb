before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  @artists = find_artists
  haml :index
end

get '/artist/:artist/:album' do
  @artist = params[:artist]
  @album = params[:album]
  @songs = find_songs
  @cover = find_cover
  haml :album
end

get '/artist/:artist' do
  @artist = params[:artist]
  @albums = find_albums
  haml :artist
end


# helpers

helpers do

  def artist_url(artist)
    "/artist/#{CGI.escape(artist)}"
  end
  
  def album_url(album)
    "/artist/#{CGI.escape(@artist)}/#{CGI.escape(album)}"
  end

  def song_url(song)
    "/music/#{CGI.escape(@artist)}/#{CGI.escape(@album)}/#{CGI.escape(song)}"
  end
  
  def song_display(song)
    song.gsub(/\.(?:mp3|mp4|aiff?|wav|m4a|mp4)$/i,'')
  end
  
  def find_artists
    Dir.entries(settings.music).grep(/^[^.]/).sort{|a,b| a.downcase <=> b.downcase}
  end

  def find_albums
    Dir.entries(File.join(settings.music,@artist)).grep(/^[^.]/).sort{|a,b| a.downcase <=> b.downcase}
  end

  def find_songs
    Dir.entries(File.join(settings.music,@artist,@album)).grep(/^[^.]/).sort{|a,b| a.downcase <=> b.downcase}
  end

  def find_cover
    # this is kind of ugly, but wanted to avoid the use of a database
    [:jpg,:png].each do |ext|
      filename = [@artist, @album].map{|s| s.downcase.gsub(/[^0-9a-z]/, '')}.join("_")
      relative = File.join('/images','large',"#{filename}.#{ext}")
      absolute = File.join(settings.public,relative)
      return relative if File.exists?(absolute)
    end
    return nil
  end
end