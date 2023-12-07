class User < ApplicationRecord
    has_secure_password
    has_many :posts
  # フォローをした、されたの関係
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
   # フォローされているユーザーの関連付け
   has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # Users that are following the current user
  has_many :followers, through: :passive_relationships, source: :follower
# ユーザーをフォローする
def follow(user_id)
  active_relationships.create(followed_id: user_id)
end
 # ユーザーのフォローを外す
 def unfollow(user_id)
  active_relationships.find_by(followed_id: user_id).destroy
 end
 # フォロー確認をおこなう
 def following?(user)
  following.include?(user)
 end
end
