class Company
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  belongs_to :user
  has_many :jobs
  validates_presence_of :name, :url
end
