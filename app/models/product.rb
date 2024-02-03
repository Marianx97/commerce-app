class Product < ApplicationRecord
  include PgSearch::Model

  validates :title, presence: :true
  validates :description, presence: :true
  validates :price, presence: :true

  has_one_attached :photo

  belongs_to :category
  belongs_to :user, default: -> { Current.user }

  pg_search_scope :search_full_text, against: {
    title: 'A',
    description: 'B'
  }
end
