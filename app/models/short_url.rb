class ShortUrl < ApplicationRecord
  belongs_to :user

  validates :original_url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9_-]+\z/, message: 'only allows letters, numbers, underscores and hyphens' }
  validates :title, length: { maximum: 255 }
  
  scope :popular, -> { order(clicks_count: :desc).limit(10) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  before_validation :generate_slug, on: :create, if: -> { slug.blank? }
  before_validation :normalize_url, if: :original_url_changed?

  # Increment clicks counter and track analytics
  def register_click!
    increment!(:clicks_count)
    Rails.cache.delete("short_url/#{slug}") # Invalidate cache to update stats
  end

  # Reset stats
  def reset_stats!
    update!(clicks_count: 0)
    Rails.cache.delete("short_url/#{slug}") # Invalidate cache after resetting
  end

  # Full short URL
  def short_url
    Rails.application.routes.url_helpers.redirect_url(slug: slug, host: ENV.fetch('APP_HOST', 'localhost:3000'))
  end

  private

  # Generate a random unique slug if not provided
  def generate_slug
    loop do
      # Use base58 encoding (no confusing characters like 0, O, I, l)
      # for better readability in URLs
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a - %w[0 O I l 1]
      self.slug = Array.new(6) { chars.sample }.join
      break unless ShortUrl.exists?(slug: slug)
    end
  end
  
  # Normalize URL to ensure it has a scheme
  def normalize_url
    return if original_url.blank?
    self.original_url = original_url.strip
    self.original_url = "http://#{original_url}" unless original_url.match?(/\A(http|https):\/\//i)
  end
end
