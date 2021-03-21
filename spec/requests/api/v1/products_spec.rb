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

      expect(response).to have_http_status(:ok)
      expect(data_count).to eq(number_of_products)
    end

    context 'when no products' do
      let(:number_of_products) { 0 }

      it 'returns a success response', :aggregate_failures do
        get api_v1_products_path

        expect(response).to have_http_status(:ok)
        expect(data_count).to eq(number_of_products)
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
        expect { post api_v1_products_path, params: params }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)

        expect(attributes).to include(create_params)
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
        expect { post api_v1_products_path, params: params }.not_to change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)

        expect(errors.dig(0, :detail)).to eq('is not a number')
      end
    end

    context 'with existing tags' do
      let(:tags) { ['Beverage', 'Calorie Free'] }
      let(:create_params) do
        {
          name: 'Coke',
          description: '24oz Bottle',
          price: '1.98',
          tags: tags
        }
      end

      before do
        tags.each do |title|
          create(:tag, title: title)
        end
      end

      it 'creates a new Product', :aggregate_failures do
        expect { post api_v1_products_path, params: params }.not_to change(Tag, :count)
        expect(response).to have_http_status(:created)

        product_tags = relationships_data('tags')
        expect(product_tags.size).to eq(tags.size)
      end
    end

    context 'with new tags' do
      let(:tags) { ['Beverage', 'Calorie Free'] }
      let(:create_params) do
        {
          name: 'Coke',
          description: '24oz Bottle',
          price: '1.98',
          tags: tags
        }
      end

      it 'creates a new Product', :aggregate_failures do
        expect { post api_v1_products_path, params: params }.to change(Tag, :count).by(2)
        expect(response).to have_http_status(:created)

        product_tags = relationships_data('tags')
        expect(product_tags.size).to eq(tags.size)
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

        expect(response).to have_http_status(:ok)
        expect(attributes).to include(update_params)
      end
    end

    context 'with invalid params' do
      let(:update_params) do
        { price: 'one and ninety eight' }
      end

      it 'returns error', :aggregate_failures do
        patch api_v1_product_path(product.id), params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors.dig(0, :detail)).to eq('is not a number')
      end
    end

    context 'when product does not exist' do
      let(:non_existing_product_id) { 123 }

      it 'returns error', :aggregate_failures do
        patch api_v1_product_path(non_existing_product_id), params: params

        expect(errors.dig(0, :detail)).to eq("Couldn't find Product with 'id'=#{non_existing_product_id}")
      end
    end

    context 'with existing tags' do
      let(:tags) { ['Calorie Free', 'No Sugar'] }
      let!(:product) { create(:product, tags: [create(:tag, title: 'Beverage')]) }
      let(:update_params) do
        { tags: tags }
      end

      before do
        tags.each do |title|
          create(:tag, title: title)
        end
      end

      it 'updates the Product', :aggregate_failures do
        expect { patch api_v1_product_path(product.id), params: params }.not_to change(Tag, :count)

        expect(response).to have_http_status(:ok)

        product_tags = relationships_data('tags')
        expect(product_tags.size).to eq(tags.size)
      end
    end

    context 'with new tags' do
      let(:tags) { ['Calorie Free', 'No Sugar'] }
      let!(:product) { create(:product, tags: [create(:tag, title: 'Beverage')]) }
      let(:update_params) do
        { tags: tags }
      end

      it 'updates the Product', :aggregate_failures do
        expect { patch api_v1_product_path(product.id), params: params }.to change(Tag, :count).by(2)

        expect(response).to have_http_status(:ok)

        product_tags = relationships_data('tags')
        expect(product_tags.size).to eq(tags.size)
      end
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let!(:product) { create(:product) }

    it 'destroys product', :aggregate_failures do
      expect { delete api_v1_product_path(product.id) }.to change(Product, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end

    context 'when product does not exist' do
      let(:non_existing_product_id) { 123 }

      it 'returns error', :aggregate_failures do
        delete api_v1_product_path(non_existing_product_id)

        expect(errors.dig(0, :detail)).to eq("Couldn't find Product with 'id'=#{non_existing_product_id}")
      end
    end

    context 'when product with tags' do
      let(:product) { create(:product, tags: [create(:tag, title: 'Beverage'), create(:tag, title: 'Calorie Free')]) }

      it 'destroys product`s tags without tags', :aggregate_failures do
        expect do
          delete api_v1_product_path(product.id)
        end.to change(Product, :count).by(-1).and change(ProductTag, :count).by(-2).and change(Tag, :count).by(0)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
