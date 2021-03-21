# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[update destroy]

      def index
        @products = Product.all

        render json: @products
      end

      def create
        @product = Product::Creator.call(product_params)
        if @product.save
          render json: @product, status: :created
        else
          render json: @product, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        @product = Product::Updater.call(@product, product_params)
        if @product.save
          render json: @product
        else
          render json: @product, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        if @product.destroy
          head :ok
        else
          render json: @product, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        @product_params ||= Product::Params.new(params)
      end
    end
  end
end
