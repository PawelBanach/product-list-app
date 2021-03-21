# frozen_string_literal: true

class Product::Creator
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    Product.new(@params.product_params).tap do |product|
      product.tag_product(@params.tags_params) unless @params.tags_params.nil?
    end
  end
end
