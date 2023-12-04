class Api::V1::PostsController < ApplicationController
  include JwtAuthenticator
  def create
    jwt_authenticate
    if @current_user.nil?
      render json: { status: 401, error: "Unauthorized" }
      return
    end
  
    token = encode(@current_user.id) # 正しいuser_idを使用する
    post = @current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created, serializer: PostSerializer, meta: { token: token }
    else
      render json: { status: 400, error: "posts not update" }
    end
  end
  
  private
  def post_params
      params.require(:post).permit(:title,:body)
  end
end
