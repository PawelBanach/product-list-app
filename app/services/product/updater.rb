# frozen_string_literal: true

class Product::Updater
  def self.call(product, params)
    new(product, params).call
  end

  def initialize(product, params)
    @product = product
    @params = params
  end

  def call
    @product.tap do |product|
      product.attributes = @params.product_params
      product.tag_product(@params.tags_params) unless @params.tags_params.nil?
    end
  end
end
