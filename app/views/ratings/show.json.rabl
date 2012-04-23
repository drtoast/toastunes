object @rating
attributes :_id, :rating, :user_id, :album_id, :updated_at, :created_at

child :album do
  attributes :_id, :title, :artist_name, :thumbnail, :library
end