# frozen_string_literal: true

require 'rails_helper'

describe Product::Updater do
  describe '.call' do
    let(:product) { create(:product) }
    let(:request_params) do
      {
        data: {
          type: 'products',
          id: product.id,
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
      updated_product = described_class.call(product, params)

      expect(updated_product.name).to eq(request_params.dig(:data, :attributes, :name))
      expect(updated_product.description).to eq(request_params.dig(:data, :attributes, :description))
      expect(updated_product.price).to eq(request_params.dig(:data, :attributes, :price).to_d)
      expect(updated_product.tags.map(&:title)).to eq(request_params.dig(:data, :attributes, :tags))
    end
  end
end
