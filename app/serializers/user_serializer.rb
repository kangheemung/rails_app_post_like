class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :posts
  has_many :following, serializer: RelationshipSerializer
  has_many :followers, serializer: RelationshipSerializer

end
