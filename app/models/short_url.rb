class ShortUrl < ApplicationRecord
  belongs_to :user

  validates :original_url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9_-]+\z/, message: 'only allows letters, numbers, underscores and hyphens' }
  validates :title, length: { maximum: 255 }

  before_validation :generate_slug, on: :create, if: -> { slug.blank? }

  private

  # Generate a random unique slug if not provided
  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6).downcase
      break unless ShortUrl.exists?(slug: slug)
    end
  end
end
