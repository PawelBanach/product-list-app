# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products, only: %i[index create update destroy]
      resources :tags, only: %i[index create update destroy]
    end
  end
end
