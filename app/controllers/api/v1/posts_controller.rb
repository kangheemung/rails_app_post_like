class Api::V1::PostsController < ApplicationController
 
  def create
    jwt_authenticate
    if @current_user.nil?
      render json: { status: 401, error: "Unauthorized" }
      return
    end
  
    token = encode(@current_user.id) # 正しいuser_idを使用する
    if post=@current_user.posts.build(post_params)
        p"=================="
        p params
        p"==================="
       render json:{status: 201,data: post,token: token}
    else
        render json:{status: 400,error: "posts not update"}
    end
  end
  private
  def post_params
      params.require(:post).permit(:title,:body ,:user_id)
  end
end
