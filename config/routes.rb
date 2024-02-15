Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :applications, param: :token
    end
  end
end
