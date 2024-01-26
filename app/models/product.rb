class Product < ApplicationRecord
  validates :title, presence: :true
  validates :description, presence: :true
  validates :price, presence: :true

  has_one_attached :photo

  belongs_to :category
end
