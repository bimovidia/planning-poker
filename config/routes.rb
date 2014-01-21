PlanningPokerRails::Application.routes.draw do
  root to: 'dashboard', action: :index

  get 'favicon.ico', controller: :application, action: :favicon

  controller :sessions do
    get    :login,  action: :new
    post   :login,  action: :create
    delete :logout, action: :destroy
  end

  resources :dashboard, only: [:index]

  controller :dashboard do
    get 'project/:id', action: :project, as: :project
    get 'story/:story_id/:vote/:user', action: :vote, as: :vote
    get 'reset/:story_id/:user', action: :reset, as: :reset
    get 'detail/:story_id/:toggle/:user', action: :detail, as: :detail
    get 'reveal/:story_id', action: :reveal, as: :reveal
    post 'select-vote', action: :select, as: :select
    post 'update-story', action: :update, as: :update
  end

end