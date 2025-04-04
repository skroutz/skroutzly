require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  let(:user) { FactoryBot.create(:user) }

  subject { FactoryBot.build(:short_url, user: user) }

  describe "validations" do
    it { should validate_presence_of(:original_url) }
    it { should validate_uniqueness_of(:slug) }

    it "validates format of slug" do
      valid_slugs = ["abc123", "my-slug", "test_url"]
      invalid_slugs = ["invalid slug", "special$char", "no/slashes"]

      valid_slugs.each do |slug|
        short_url = FactoryBot.build(:short_url, slug: slug, user: user)
        expect(short_url).to be_valid
      end

      invalid_slugs.each do |slug|
        short_url = FactoryBot.build(:short_url, slug: slug, user: user)
        expect(short_url).to be_invalid
        expect(short_url.errors[:slug]).to include("only allows letters, numbers, underscores and hyphens")
      end
    end

    it "validates URLs" do
      valid_urls = ["https://example.com", "http://test.org/path"]
      invalid_urls = ["not-a-url", "ftp://example.com"]

      valid_urls.each do |url|
        short_url = FactoryBot.build(:short_url, original_url: url, user: user)
        expect(short_url).to be_valid
      end

      invalid_urls.each do |url|
        short_url = FactoryBot.build(:short_url, original_url: url, user: user)
        expect(short_url).to be_invalid
        expect(short_url.errors[:original_url]).to include("is not a valid URL")
      end
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "slug generation" do
    it "automatically generates a slug if not provided" do
      short_url = FactoryBot.create(:short_url, slug: nil, user: user)
      expect(short_url.slug).to be_present
      expect(short_url.slug.length).to eq(6)
    end

    it "uses the provided slug if given" do
      short_url = FactoryBot.create(:short_url, slug: "custom", user: user)
      expect(short_url.slug).to eq("custom")
    end
  end

  describe "instance methods" do
    let(:short_url) { FactoryBot.create(:short_url, user: user) }

    it "registers clicks" do
      expect { short_url.register_click! }.to change { short_url.clicks_count }.by(1)
    end

    it "returns the full short URL" do
      allow(Rails.application.routes.url_helpers).to receive(:redirect_url).and_return("http://localhost:3000/#{short_url.slug}")
      expect(short_url.short_url).to eq("http://localhost:3000/#{short_url.slug}")
    end
  end
end
