class User
	include Mongoid::Document
  include ActiveModel::SecurePassword
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :email_verify_token, type: String
  field :email_verified, type: Boolean
  field :forgot_password, type: String 
  embeds_one :facebook_profile
  has_secure_password
  has_many :companies
  has_and_belongs_to_many :jobs
  validates_presence_of :name, :email
end
