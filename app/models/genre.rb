class Genre
  include Mongoid::Document
  field :name, :type => String
  references_many :albums
end
