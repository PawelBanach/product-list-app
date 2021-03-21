# frozen_string_literal: true

require 'rails_helper'

describe 'Tags', type: :request do
  describe 'GET /api/v1/tags' do
    let(:number_of_tags) { 3 }

    before do
      create_list(:tag, number_of_tags)
    end

    it 'returns a success response', :aggregate_failures do
      get api_v1_tags_path

      expect(response).to have_http_status(:ok)
      expect(data_count).to eq(number_of_tags)
    end

    context 'when no tags' do
      let(:number_of_tags) { 0 }

      it 'returns a success response', :aggregate_failures do
        get api_v1_tags_path

        expect(response.status).to eq(200)
        expect(data_count).to eq(number_of_tags)
      end
    end
  end

  describe 'POST /api/v1/tags' do
    let(:create_params) do
      { title: 'Beverage' }
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
      it 'creates a new Tag', :aggregate_failures do
        expect { post api_v1_tags_path, params: params }.to change(Tag, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(attributes).to include(create_params)
      end
    end

    context 'with invalid params' do
      let(:create_params) do
        { title: 'Beverage' }
      end

      before do
        create(:tag, create_params)
      end

      it 'returns error', :aggregate_failures do
        expect { post api_v1_tags_path, params: params }.not_to change(Tag, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors.dig(0, :detail)).to eq('has already been taken')
      end
    end
  end

  describe 'PATCH /api/v1/tags/:id' do
    let(:tag) { create(:tag) }
    let(:update_params) do
      { title: 'Calorie Free' }
    end
    let(:params) do
      {
        data: {
          type: 'tags',
          id: tag.id,
          attributes: update_params
        }
      }
    end

    context 'with valid params' do
      it 'updates the Tag', :aggregate_failures do
        patch api_v1_tag_path(tag.id), params: params

        expect(response).to have_http_status(:ok)
        expect(attributes).to include(update_params)
      end
    end

    context 'with invalid params' do
      let(:update_params) do
        { title: nil }
      end

      it 'returns error', :aggregate_failures do
        patch api_v1_tag_path(tag.id), params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors.dig(0, :detail)).to eq("can't be blank")
      end
    end

    context 'when tag does not exist' do
      let(:non_existing_tag_id) { 123 }

      it 'returns error', :aggregate_failures do
        patch api_v1_tag_path(non_existing_tag_id), params: params

        expect(errors.dig(0, :detail)).to eq("Couldn't find Tag with 'id'=#{non_existing_tag_id}")
      end
    end
  end

  describe 'DELETE /api/v1/tags/:id' do
    let!(:tag) { create(:tag) }

    it 'destroys tag', :aggregate_failures do
      expect { delete api_v1_tag_path(tag.id) }.to change(Tag, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end

    context 'when tag does not exist' do
      let(:non_existing_tag_id) { 123 }

      it 'returns error', :aggregate_failures do
        delete api_v1_tag_path(non_existing_tag_id)

        expect(errors.dig(0, :detail)).to eq("Couldn't find Tag with 'id'=#{non_existing_tag_id}")
      end
    end

    context 'when tag has associated objects' do
      before do
        create(:product, tags: [tag])
      end

      it 'returns error', :aggregate_failures do
        delete api_v1_tag_path(tag.id)

        expect(errors.dig(0, :detail)).to eq('Cannot delete record because dependent product tags exist')
      end
    end
  end
end
