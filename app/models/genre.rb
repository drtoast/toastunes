class Genre
  include Mongoid::Document
  field :name, :type => String
  references_many :albums
  
  # Replace an old genre with a new one
  #
  # Genre.swap("Rock", "Rock & Roll")
  def self.swap(old_genre_name, new_genre_name)
    old_genre = Genre.where(:name => old_genre_name).first
    return unless old_genre
    new_genre = Genre.where(:name => new_genre_name).first || Genre.create!(:name => new_genre_name)
    old_genre.albums.each do |album|
      puts [new_genre.name, album.title].join("\t")
      album.genre = new_genre
      album.save
    end
    true
  end
  
  # Delete all genres that have no albums
  def self.cleanup
    Genre.all.each do |genre|
      if genre.albums.empty?
        puts "Deleting #{genre.name}"
        genre.destroy
      end
    end
    true
  end
  
end
