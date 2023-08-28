# == Schema Information
#
# Table name: ranks
#
#  id   :bigint           not null, primary key
#  date :datetime
#
class Rank < ApplicationRecord
  has_many :book_ranks, dependent: :nullify
end
