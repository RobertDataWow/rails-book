class RankApi < Grape::API
  resource :ranks do
    desc 'GET /api/v1/ranks'
    get do
      status 200
      RankSerializer.new(Rank.all)
    end
  end
end
