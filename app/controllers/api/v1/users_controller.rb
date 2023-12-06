class Api::V1::UsersController < ApplicationController
  skip_before_action :jwt_authenticate, only: [:create]
  
  def create
    user = User.new(user_params)
    if user.save
      token = encode(user.id)
      render json: {status: 200, data: {name: user.name, email: user.email, token: token}}
    else
      render json: {status: 400, error: "User cannot be created"}
    end
  end 

  def show
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
    user = User.find(params[:id])
    posts = user.posts.all
    
    serialized_user = UserSerializer.new(user).as_json
    token = encode(user.id)
    
    render json: {
      status: 200,
      data: {
        user: serialized_user,
        token: token,
        posts: posts.as_json(only: [:id, :title, :content])
      }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, error: "User not found" }
  end

  def update
    jwt_authenticate
    return render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized if @current_user.nil?
    
    user = User.find(params[:id])
    token = encode(user.id)
    
    if user.update(user_params)
      render json: {status: 200, data: {name: user.name, email: user.email, token: token}}
    else
      render json: {status: 400, error: "User cannot be updated"}
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
