class Job
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :salary, type: Float
  field :location, type: Array
  field :hours, type: Integer
  field :created_at, type: DateTime
  index({ location: "2d" }, { min: -180, max: 180 })
  belongs_to :company
  has_and_belongs_to_many :users
  validates_presence_of :title, :salary, :location, :created_at
end
