# frozen_string_literal: true

require 'rails_helper'

describe Product::Params do
  subject(:product_params) { described_class.new(ActionController::Parameters.new(request_params)) }

  let(:attributes) do
    {
      name: 'Coke',
      description: '24oz Bottle',
      price: '1.98',
      tags: ['Beverage', 'Calorie Free']
    }
  end
  let(:request_params) do
    {
      data: {
        type: 'undefined',
        id: 'undefined',
        attributes: attributes
      }
    }
  end

  describe '.product_params' do
    it 'returns params except tags' do
      expect(product_params.product_params.to_h).to include(attributes.except(:tags))
    end
  end

  describe '.tags_params' do
    it 'returns tags params' do
      expect(product_params.tags_params).to eq(attributes[:tags])
    end
  end
end
