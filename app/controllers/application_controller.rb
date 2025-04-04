class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActionView::RecordIdentifier # Add this to access dom_id in controllers

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
