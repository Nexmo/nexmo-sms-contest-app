Rails.application.routes.draw do
  get '/webhooks/receive', to: 'message#create'
end
