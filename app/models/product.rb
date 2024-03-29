class Product < ApplicationRecord
  include PgSearch::Model
  include Favoritable

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

  def owner?
    user_id == Current.user&.id
  end

  def broadcast
    broadcast_replace_to self, partial: 'products/product_details',
                               locals: { product: self }
  end
end
