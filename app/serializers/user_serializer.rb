class UserSerializer < ActiveModel::Serializer
  attributes :name,:email,:id
  has_many :posts
end
