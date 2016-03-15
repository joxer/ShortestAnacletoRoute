Rails.application.routes.draw do
  get 'search/:start_path/:end_path', to: 'search#search_route'
  get 'search/home', to: 'search#home'

  root 'search#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
