class Comment

  # include Mongoid::Document
  # include Mongoid::Timestamps

  # field :body, :type => String
  # index :created_at

  # referenced_in :album
  # referenced_in :user

  # Album.first.comments << Comment.new(:user => User.first, :body => "some comment", :rating => 80)
  # Album.first.comments.first.user.email
  # => "toast@drtoast.com"

  def as_json(options={})
    attrs = super(options)
    attrs['album'] = album.as_json
    attrs['user'] = user.as_json
    attrs
  end

end
