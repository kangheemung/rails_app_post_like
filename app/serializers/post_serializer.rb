class PostSerializer < ActiveModel::Serializer
  attributes :title, :body
  # 欲しい関連付け
  belongs_to :user
end
