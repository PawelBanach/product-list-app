# frozen_string_literal: true

class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag

  validates :product, presence: true
  validates :tag, presence: true
end
