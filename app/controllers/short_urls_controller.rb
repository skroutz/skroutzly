class ShortUrlsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_short_url, only: %i[ show edit update destroy reset_stats ]

  # GET /short_urls
  def index
    @pagy, @short_urls = pagy(current_user.short_urls.order(id: :desc))

    # For the new short URL form
    @short_url = ShortUrl.new
  end

  # GET /short_urls/1
  def show
  end

  # GET /short_urls/new
  def new
    @short_url = ShortUrl.new
  end

  # GET /short_urls/1/edit
  def edit
  end

  # POST /short_urls
  def create
    @short_url = current_user.short_urls.build(short_url_params)

    if @short_url.save
      redirect_to @short_url, notice: "Short url was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /short_urls/1
  def update
    if @short_url.update(short_url_params)
      redirect_to @short_url, notice: "Short url was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /short_urls/1
  def destroy
    @short_url.destroy!
    redirect_to short_urls_path, notice: "Short url was successfully destroyed.", status: :see_other
  end

  # POST /short_urls/1/reset_stats
  def reset_stats
    @short_url.reset_stats!
    redirect_to @short_url, notice: "Statistics reset successfully."
  end

  # GET /:slug - Redirect to the original URL
  def redirect
    @short_url = ShortUrl.find_by!(slug: params[:slug])
    @short_url.register_click!

    redirect_to @short_url.original_url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Sorry, that short URL doesn't exist"
    redirect_to root_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_short_url
    @short_url = current_user.short_urls.find(params.expect(:id))
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You don't have access to that short URL"
    redirect_to short_urls_path
  end

  # Only allow a list of trusted parameters through.
  def short_url_params
    params.expect(short_url: [ :original_url, :slug, :title ])
  end
end
