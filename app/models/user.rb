class User
	include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :email_verify_token, type: String
  field :forgot_password, type: String 
  embeds_one :facebook_profile
  has_many :companies
  has_and_belongs_to_many :jobs
  validates_presence_of :name, :email, :password
end
