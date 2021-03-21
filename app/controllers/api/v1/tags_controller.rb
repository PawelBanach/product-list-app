# frozen_string_literal: true

module Api
  module V1
    class TagsController < ApplicationController
      before_action :set_tag, only: %i[update destroy]

      def index
        @tags = Tag.all

        render json: @tags
      end

      def create
        @tag = Tag.new(tag_params)

        if @tag.save
          render json: @tag, status: :created
        else
          render json: @tag, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        if @tag.update(tag_params)
          render json: @tag
        else
          render json: @tag, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        if @tag.destroy
          head :ok
        else
          render json: @tag, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      private

      def set_tag
        @tag = Tag.find(params[:id])
      end

      def tag_params
        params.require(:data).require(:attributes).permit(:title)
      end
    end
  end
end
