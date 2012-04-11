class Comment
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, :type => String
  index :created_at
  
  referenced_in :album
  referenced_in :user
  
  # Album.first.comments << Comment.new(:user => User.first, :body => "some comment", :rating => 80)
  # Album.first.comments.first.user.email
  # => "toast@drtoast.com"

  def as_json(options={})
    attrs = super(options)
    attrs['album_thumbnail'] = album.thumbnail
    attrs['album_library'] = album.library
    attrs['album_title'] = album.title
    attrs['artist_name'] = album.artist_name
    attrs['user_name'] = user.name
    attrs
  end

end
