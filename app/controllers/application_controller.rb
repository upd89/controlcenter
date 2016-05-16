class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :success, :warning, :error, :info

  before_action :require_login

  rescue_from ActiveRecord::RecordNotFound, with: :go_to_index

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to({action: "index"}, warning: exception.message)
  end

  def go_to_index
    redirect_to({action: "index"}, warning: 'Entry with the ID ' + params[:id] + ' not found')
  end

  private
  def not_authenticated
    redirect_to login_path, warning: "Please login first"
  end
end
