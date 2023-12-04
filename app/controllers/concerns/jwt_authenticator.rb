module JwtAuthenticator
    require 'jwt'
    require 'dotenv/load'

    def jwt_authenticate
        raise 'ヘッダーにjwtトークンがなかったら' unless request.headers['Authorization'].present?
        raise 'ヘッダーが正しくないです。' unless request.headers['Authorization'].split(' ').first == 'Bearer'
        token = request.headers['Authorization'].split(' ').last
        decoded_token = decode(token)
        @current_user = User.find_by(id: decoded_token['user_id'])
      #raise 'ユーザーが存在しません'unless @current_user
    end
    def encode(user_id)
        expires_in = 1.day.from_now.to_i
        payload = {user_id: user_id, exp: expires_in}
        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    end
    
    def decode(token)
        decode_jwt = JWT.decode(token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
        decode_jwt.first
    end
end    