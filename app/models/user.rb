require 'digest/md5'

class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :registerable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation

  field :name, :type => String
  
  
  references_many :comments
  references_many :ratings
  references_many :albums
  
  # TODO: this should be field :admin, :type => Boolean
  # but not sure how to make that work with Devise
  def admin?
    Toastunes::Application.config.admins.include?(id.to_s)
  end
  
  def gravatar
    hash = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{hash}.jpg?s=75"
  end
  
end
