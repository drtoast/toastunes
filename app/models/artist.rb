class Artist
  include Mongoid::Document
  field :name, :type => String
  index :name
  
  references_many :albums
end
