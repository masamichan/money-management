Rails.application.routes.draw do
  namespace :portal do
    get 'client/settings'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
