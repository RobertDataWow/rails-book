class RanksController < ApplicationController
  def index
    @ranks = Rank.page(params[:page])
  end
end
