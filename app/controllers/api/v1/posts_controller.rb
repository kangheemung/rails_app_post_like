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
      render json: { status: 400, error: "posts not create" }
    end
  end
  
  def update
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
    token = encode(@current_user.id)
    post = Post.find_by(id: params[:id])
  
    if post.nil?
      render json: { status: :not_found, error: "Post not found" }, status: :not_found
      return
    end
    
    if post.update(post_params) # Assuming `post_params` is a method that whitelists your post parameters.
      render json: post, status: :ok, serializer: PostSerializer, meta: { token: token }
    else
      render json: { status: :bad_request, error: "Post could not be updated" }, status: :bad_request
    end
  end
  def destroy # Usually, the method for号室 deleting resources in Rails is named `destroy`, not `delete`.
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
  
    post = Post.find_by(id: params[:id])
    
    # It might be worth checking whether the @current_user has permissions to delete the post.
    if post.present? && post.destroy
      # When you are serializing one record, you have to wrap it using a key that matches the serializer
      render json: { post: PostSerializer.new(post), meta: { token: encode(@current_user.id) } }, status: :ok
    elsif post.nil?
      render json: { status: :not_found, error: "Post not found" }, status: :not_found
    else
      render json: { status: :bad_request, error: "Post could not be deleted" }, status: :bad_request
    end
  end
  
  
  private
  def post_params
      params.require(:post).permit(:title,:body)
  end
end
