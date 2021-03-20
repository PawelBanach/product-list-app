# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: [{ id: params[:id], detail: exception.message }] }, status: :not_found
  end
end
