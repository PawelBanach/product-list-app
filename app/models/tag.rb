# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :product_tags, dependent: :restrict_with_error
  has_many :products, through: :product_tags

  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
