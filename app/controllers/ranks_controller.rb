class RanksController < ApplicationController
  before_action :authenticate_user!

  def index
    @ranks = Rank.page(params[:page])
  end
end
