require 'digest/md5'

class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :registerable, :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :unique => true

  field :name, :type => String
  field :admin, :type => Boolean
  field :approved, :type => Boolean
  
  references_many :comments
  references_many :ratings
  references_many :albums
  
  def gravatar
    hash = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{hash}.jpg?s=75"
  end
  
  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
end
