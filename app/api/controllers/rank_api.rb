class RankApi < Grape::API
  resource :ranks do
    desc 'GET /api/v1/ranks'
    get do
      RankSerializer.new(Rank.all).serializable_hash
    end
  end
end
