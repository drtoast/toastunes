class Artist
  include Mongoid::Document
  field :name, :type => String
  index name: 1

  has_many :albums
end
