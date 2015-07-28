class Job
  include Geocoder::Model::Mongoid
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :salary, type: Float
  field :location, type: Array
  field :hours, type: Integer
  field :created_at, type: DateTime
  field :responsibility, type: String
  field :jobmatches, type: Array
  field :address, type: String
  index({ location: "2d" }, { min: -180, max: 180 })
  belongs_to :company
  has_and_belongs_to_many :users
  validates_presence_of :title, :salary, :location, :created_at
  reverse_geocoded_by :coordinates
  after_validation :reverse_geocode

  def coordinates
    return [location[1], location[0]]
  end
end
