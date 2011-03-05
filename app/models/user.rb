require 'digest/md5'

class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :registerable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation

  field :name, :type => String
  field :admin, :type => Boolean
  
  references_many :comments
  references_many :ratings
  
  def gravatar
    hash = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{hash}.jpg?s=75"
  end
  
end
