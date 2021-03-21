# frozen_string_literal: true

class Product::Params
  def initialize(params)
    @params = params.require(:data).require(:attributes).permit(:name, :description, :price, tags: [])
  end

  def product_params
    @params.except(:tags)
  end

  def tags_params
    @params[:tags]
  end
end
