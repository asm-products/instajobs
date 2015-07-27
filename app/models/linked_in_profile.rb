class LinkedInProfile
  include Mongoid::Document
  field :uid, type: String
  field :first_name, type: String
  field :last_name, type: String
  embedded_in :user
end
