# frozen_string_literal: true

require 'rails_helper'

describe 'Products', type: :request do
  describe 'GET /api/v1/products' do
    let(:number_of_products) { 3 }

    before do
      create_list(:product, number_of_products)
    end

    it 'returns a success response', :aggregate_failures do
      get api_v1_products_path

      expect(response).to have_http_status(200)
      expect(parse_json(response.body)['data'].size).to eq(number_of_products)
    end

    context 'when no products' do
      let(:number_of_products) { 0 }

      it 'returns a success response', :aggregate_failures do
        get api_v1_products_path

        expect(response.status).to eq(200)
        expect(parse_json(response.body)['data'].size).to eq(number_of_products)
      end
    end
  end

  describe 'POST /api/v1/products' do
    let(:create_params) do
      {
        name: 'Coke',
        description: '24oz Bottle',
        price: '1.98'
      }
    end
    let(:params) do
      {
        data: {
          type: 'undefined',
          id: 'undefined',
          attributes: create_params
        }
      }
    end

    context 'with valid params' do
      it 'creates a new Product', :aggregate_failures do
        expect do
          post api_v1_products_path, params: params
        end.to change(Product, :count).by(1)

        expect(response).to have_http_status(201)

        new_product = parse_json(response.body)['data']['attributes'].symbolize_keys
        expect(new_product).to include(create_params)
      end
    end

    context 'with invalid params' do
      let(:create_params) do
        {
          name: 'Coke',
          description: '24oz Bottle',
          price: 'one and ninety eight'
        }
      end

      it 'returns error', :aggregate_failures do
        expect do
          post api_v1_products_path, params: params
        end.to_not change(Product, :count)

        expect(response).to have_http_status(422)

        error = parse_json(response.body)['errors'].first.symbolize_keys
        expect(error[:detail]).to eq('is not a number')
      end
    end
  end

  describe 'PATCH /api/v1/products/:id' do
    let(:product) { create(:product) }
    let(:update_params) do
      { name: 'Pepsi Lemon' }
    end
    let(:params) do
      {
        data: {
          type: 'products',
          id: product.id,
          attributes: update_params
        }
      }
    end

    context 'with valid params' do
      it 'updates the Product', :aggregate_failures do
        patch api_v1_product_path(product.id), params: params

        expect(response).to have_http_status(200)

        updated_product = parse_json(response.body)['data']['attributes'].symbolize_keys
        expect(updated_product).to include(update_params)
      end
    end

    context 'with invalid params' do
      let(:update_params) do
        { price: 'one and ninety eight' }
      end

      it 'returns error', :aggregate_failures do
        patch api_v1_product_path(product.id), params: params

        expect(response).to have_http_status(422)

        error = parse_json(response.body)['errors'].first.symbolize_keys
        expect(error[:detail]).to eq('is not a number')
      end
    end

    context 'when product does not exist' do
      let(:non_existing_product_id) { 123 }

      it 'returns error', :aggregate_failures do
        patch api_v1_product_path(non_existing_product_id), params: params

        error = parse_json(response.body)['errors'].first.symbolize_keys
        expect(error[:detail]).to eq("Couldn't find Product with 'id'=#{non_existing_product_id}")
      end
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let!(:product) { create(:product) }

    it 'destroys product', :aggregate_failures do
      expect do
        delete api_v1_product_path(product.id)
      end.to change(Product, :count).by(-1)

      expect(response).to have_http_status(204)
    end

    context 'when product does not exist' do
      let(:non_existing_product_id) { 123 }

      it 'returns error', :aggregate_failures do
        delete api_v1_product_path(non_existing_product_id)

        error = parse_json(response.body)['errors'].first.symbolize_keys
        expect(error[:detail]).to eq("Couldn't find Product with 'id'=#{non_existing_product_id}")
      end
    end
  end
end
