class Toastunes::Library
  
=begin
  # BOOTSTRAP:
  l = Toastunes::Library.new
  l.destroy_all!
  l.load_itunes
  l.process_albums
=end
  
  def destroy_all!    
    [Album, Artist, Comment, Genre, Rating].each do |klass|
      puts "deleting all #{klass.name.pluralize}"
      klass.destroy_all
    end
  end
  
  def load_itunes
    TunesParser.parse!
  end
  
  def process_albums
    Album.all.each do |a|
      begin
        a.extract_cover
        a.set_artist
        a.set_genre
        a.save
        puts [a.id, a.artist_name, a.title].join("\t")
      rescue => e
        puts "ERROR processing album #{a.id} (#{a.title})"
        raise e
      end
    end
  end
  
  def load_directory(dir)
    p = Toastunes::DirectoryParser.new
    p.parse!(dir)
  end
  
end