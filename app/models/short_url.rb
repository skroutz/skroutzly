class ShortUrl < ApplicationRecord
  belongs_to :user

  validates :original_url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9_-]+\z/, message: 'only allows letters, numbers, underscores and hyphens' }
  validates :title, length: { maximum: 255 }

  before_validation :generate_slug, on: :create, if: -> { slug.blank? }

  # Increment clicks counter
  def register_click!
    increment!(:clicks_count)
  end

  # Reset stats
  def reset_stats!
    update!(clicks_count: 0)
  end

  # Full short URL
  def short_url
    Rails.application.routes.url_helpers.redirect_url(slug: slug, host: ENV.fetch('APP_HOST', 'localhost:3000'))
  end

  private

  # Generate a random unique slug if not provided
  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6).downcase
      break unless ShortUrl.exists?(slug: slug)
    end
  end
end
