# frozen_string_literal: true

class Product::TagsSetter
  def self.call(product, tags_titles)
    new(product, tags_titles).call
  end

  def initialize(product, tags_titles)
    @product = product
    @tags_titles = tags_titles
  end

  def call
    @product.tap do |product|
      product.tags = existing_tags + non_existing_tags
    end
  end

  def non_existing_tags
    @non_existing_tags ||= (@tags_titles - existing_tags.pluck(:title)).map { |title| Tag.new(title: title) }
  end

  def existing_tags
    @existing_tags ||= Tag.where(title: @tags_titles)
  end
end
