class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  layout :layout_by_resource

  private

  # Signed-out Devise pages (log in, sign up, passwords) use the split-panel
  # auth layout; editing your account stays inside the app.
  def layout_by_resource
    if devise_controller? && !(controller_name == "registrations" && action_name.in?(%w[edit update]))
      "auth"
    else
      "application"
    end
  end
end
