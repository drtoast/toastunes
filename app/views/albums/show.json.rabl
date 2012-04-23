object @album
attributes :_id, :artist_id, :artist_name, :compilation, :cover, :created_at, :genre_id, :library, :random_number, :rating, :thumbnail, :title
child :tracks do
  #:rating, :created_at, :played_at, :kind, :size, :duration, :year, :bit_rate, :sample_rate, :itunes_pid, :track_count, :genre
  attributes :_id, :title, :location, :track, :artist_name
end