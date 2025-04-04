class PagesController < ApplicationController
  def home
    # Redirect to authenticated root if user is signed in
    redirect_to authenticated_root_path if user_signed_in?
  end
end
