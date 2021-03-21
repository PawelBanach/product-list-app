# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :product_tags, inverse_of: :product, dependent: :destroy
  has_many :tags, through: :product_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def tag_product(tags_titles)
    Product::TagsSetter.call(self, tags_titles)
  end
end
