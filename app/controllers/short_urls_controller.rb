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
    preowned_short_urls_count = current_user.short_urls.count
    @short_url = current_user.short_urls.build(short_url_params)

    respond_to do |format|
      if @short_url.save
        @pagy, @short_urls = pagy(current_user.short_urls.order(id: :desc))

        format.html { redirect_to short_urls_path, notice: "Short URL was successfully created." }
        format.turbo_stream do
          flash.now[:notice] = "Short URL was successfully created."
          # For the empty state, we need to handle it differently
          if preowned_short_urls_count.zero?
            # If this is the first URL, replace the entire content and include the new URL
            render turbo_stream: [
              turbo_stream.update("url_list_container", partial: "short_urls/url_list", locals: { short_urls: @short_urls, pagy: @pagy }),
              turbo_stream.replace("new_short_url", partial: "short_urls/form", locals: { short_url: ShortUrl.new }),
              turbo_stream.append("flash", partial: "layouts/flash")
            ]
          else
            # Append the new row to the table body
            render turbo_stream: [
              turbo_stream.prepend("short_urls", partial: "short_urls/short_url", locals: { short_url: @short_url }),
              turbo_stream.replace("new_short_url", partial: "short_urls/form", locals: { short_url: ShortUrl.new }),
              turbo_stream.append("flash", partial: "layouts/flash")
            ]
          end
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          flash.now[:alert] = "Short URL was not created."
          render turbo_stream: [
            turbo_stream.replace("new_short_url", partial: "short_urls/form", locals: { short_url: @short_url }),
            turbo_stream.append("flash", partial: "layouts/flash")
          ]
        end
      end
    end
  end

  # PATCH/PUT /short_urls/1
  def update
    respond_to do |format|
      if @short_url.update(short_url_params)
        format.html { redirect_to short_url_path(@short_url), notice: "Short URL was successfully updated." }
        format.turbo_stream do
          flash.now[:notice] = "Short URL was successfully updated."
          render turbo_stream: [
            turbo_stream.replace(@short_url,
              template: "short_urls/show",
              locals: { short_url: @short_url }),
            turbo_stream.append("flash", partial: "layouts/flash")
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          flash.now[:alert] = "Short URL was not updated."
          render turbo_stream: turbo_stream.append("flash", partial: "layouts/flash")
        end
      end
    end
  end

  # DELETE /short_urls/1
  def destroy
    # Store the ID before destroying the record
    url_id = dom_id(@short_url)
    @short_url.destroy

    respond_to do |format|
      # Reload @short_urls after deletion
      @pagy, @short_urls = pagy(current_user.short_urls.order(id: :desc))

      format.html { redirect_to short_urls_url, notice: "Short URL was successfully destroyed." }
      format.turbo_stream do
        flash.now[:notice] = "Short URL was successfully destroyed."

        if current_user.short_urls.count.zero?
          # If no URLs left, update the entire container to show empty state
          render turbo_stream: [
            turbo_stream.update("url_list_container", partial: "url_list", locals: { short_urls: @short_urls, pagy: @pagy }),
            turbo_stream.update("flash", partial: "layouts/flash")
          ]
        else
          # Otherwise just remove the deleted entry by its DOM ID
          render turbo_stream: [
            turbo_stream.remove(url_id),
            turbo_stream.update("flash", partial: "layouts/flash")
          ]
        end
      end
    end
  end

  # POST /short_urls/1/reset_stats
  def reset_stats
    @short_url.reset_stats!

    respond_to do |format|
      format.html { redirect_to short_url_path(@short_url), notice: "Statistics reset successfully." }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(@short_url, template: "short_urls/show", locals: { short_url: @short_url })
        ]
      end
    end
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
