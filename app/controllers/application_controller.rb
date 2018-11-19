class ApplicationController < ActionController::Base
  add_flash_types :success, :warning, :danger, :info
  skip_before_action :verify_authenticity_token
  rescue_from ActionController::ParameterMissing, with: :missing_params

  def missing_params(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
  private :missing_params
end
