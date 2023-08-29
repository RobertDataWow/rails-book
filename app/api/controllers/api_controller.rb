class ApiController < Grape::API
  version 'v1', using: :path
  format :json
  helpers ApiHelper

  before { error!('Unauthorized', 401) unless current_user }

  mount BookApi
  mount ReviewApi
  mount RankApi
end
