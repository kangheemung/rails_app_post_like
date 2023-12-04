class ApplicationController < ActionController::API
    include JwtAuthenticator
    before_action :jwt_authenticate
end
