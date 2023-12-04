class Api::V1::UsersController < ApplicationController
    skip_before_action :jwt_authenticate, only: [:create]
    def create
        user=User.new(user_params)
        if user.save
        token = encode(user.id)
        render json:{status:200,data: {name: user.name, email: user.email, token: token}}
        else
        render json: {status:400,error: "users can't save and create"}
        end
    end
    private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

end
