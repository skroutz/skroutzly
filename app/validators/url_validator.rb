class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      uri = URI.parse(value)
      valid = uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      valid = false
    end

    unless valid
      record.errors.add(attribute, options[:message] || "is not a valid URL")
    end
  end
end
