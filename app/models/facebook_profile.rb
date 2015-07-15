class FacebookProfile
  include Mongoid::Document
  field :uid, type: Integer
  field :accesss_token, type: String
  embedded_in :user
end
