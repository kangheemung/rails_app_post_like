Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth'=>'auth#create'
       resources :users do
        resources :posts
        member do
          post 'follow', to: 'relationships#create'
          delete 'unfollow', to: 'relationships#destroy'
        end
       end
    end
  end  
end
