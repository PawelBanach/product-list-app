# frozen_string_literal: true

require 'rails_helper'

describe Product::TagsSetter do
  subject(:tags_setter) { described_class.new(product, tag_titles) }

  let(:product) { build(:product) }
  let(:tag_titles) { ['Beverage', 'Calorie Free'] }

  describe '.call' do
    it 'sets tag titles for a given product' do
      tags_setter.call

      expect(product.tags.map(&:title)).to eq(tag_titles)
    end
  end
end
