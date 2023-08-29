class RankApi < Grape::API
  resource :ranks do
    desc 'Get Book Ranks'
    get do
      RankSerializer.new(Rank.all).serializable_hash
    end
  end
end
