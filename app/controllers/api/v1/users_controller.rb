class Api::V1::UsersController < ApplicationController
  before_action :jwt_authenticate, except: [:create]
  before_action :set_current_user, only: [:show, :update, :follow, :following]

  def create
    user = User.new(user_params)
    if user.save
      token = encode(user.id)
      render json: { status: 200, data: { name: user.name, email: user.email, token: token } }
    else
      render json: { status: 400, error: "User cannot be created" }
    end
  end 

  def show
    user = @current_user || User.find(params[:id])
    posts = user.posts.all
    
    serialized_user = UserSerializer.new(user).as_json
    following_users = user.following_users
    follower_users = user.follower_users
    
    render json: {
      status: 200,
      data: {
        user: serialized_user,
        posts: posts.as_json(only: [:id, :title, :content]),
        following_users: following_users,
        follower_users: follower_users
      }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, error: "User not found" }
  end

  # ...

  # POST /api/v1/users/:id/follow
  def follow
    target_user = User.find_by(id: params[:id])
    unless target_user
      return render json: { status: 404, error: "User not found" }, status: :not_found
    end
    
    if @current_user.id == target_user.id
      render json: { status: 400, error: "You cannot follow yourself" }, status: :bad_request
    elsif @current_user.following?(target_user)
      render json: { status: 400, error: "Already following" }, status: :bad_request
    elsif @current_user.follow(target_user.id)
      render json: { status: 200, message: "Successfully followed #{target_user.name}" }, status: :ok
    else
      render json: { status: 400, error: "Could not follow user" }, status: :bad_request
    end
  end
  
  # GET /api/v1/users/:id/following
  def following
    render json: { status: 200, data: @current_user.following_users }, status: :ok
  end

  private

  def set_current_user
    @current_user = jwt_authenticate
    render json: { status: :unauthorized, error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
