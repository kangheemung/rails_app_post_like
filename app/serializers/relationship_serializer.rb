class RelationshipSerializer < ActiveModel::Serializer

  attributes :id, :follower_id, :followed_id

  belongs_to :follower, serializer: UserSerializer
  belongs_to :followed, serializer: UserSerializer
end
