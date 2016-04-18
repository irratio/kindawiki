Rails.application.routes.draw do
  root 'pages#index'

  scope format: false do
    get    '/(*path)/add',  to: 'pages#new',    as: :new_page
    get    '/(*path)/edit', to: 'pages#edit',   as: :edit_page
    get    '/(*path)',      to: 'pages#show',   as: :page
    post   '/(*path)/add',  to: 'pages#create'
    patch  '/(*path)/edit', to: 'pages#update'
    put    '/(*path)/edit', to: 'pages#update'
    delete '/(*path)',      to: 'pages#destroy'
  end
end
