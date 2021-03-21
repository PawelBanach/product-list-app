# frozen_string_literal: true

require 'rails_helper'

describe Product::Creator do
  describe '.call' do
    let(:request_params) do
      {
        data: {
          type: 'undefined',
          id: 'undefined',
          attributes: {
            name: 'Coke',
            description: '24oz Bottle',
            price: '1.98',
            tags: ['Beverage', 'Calorie Free']
          }
        }
      }
    end
    let(:params) do
      Product::Params.new(
        ActionController::Parameters.new(request_params)
      )
    end

    it 'prepares record for create', :aggregate_failures do
      product = described_class.call(params)

      expect(product.name).to eq(request_params.dig(:data, :attributes, :name))
      expect(product.description).to eq(request_params.dig(:data, :attributes, :description))
      expect(product.price).to eq(request_params.dig(:data, :attributes, :price).to_d)
      expect(product.tags.map(&:title)).to eq(request_params.dig(:data, :attributes, :tags))
    end
  end
end
