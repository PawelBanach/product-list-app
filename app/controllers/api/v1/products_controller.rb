module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show update destroy]

      def index
        @products = Product.all

        render json: @products
      end

      def create
        @product = Product.new(product_params)

        if @product.save
          render json: @product, status: :created
        else
          render json: @product, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: @product, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        @product.destroy
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:data).require(:attributes).permit(:name, :description, :price)
      end
    end
  end
end
