class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: %i[ show edit update destroy ]

  # GET /short_urls
  def index
    @short_urls = ShortUrl.all
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
    @short_url = ShortUrl.new(short_url_params)

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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_short_url
    @short_url = ShortUrl.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def short_url_params
    params.expect(short_url: [ :original_url, :slug, :title, :user_id, :clicks_count ])
  end
end
