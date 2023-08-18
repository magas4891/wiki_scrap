# frozen_string_literal: true

module Wiki
  class Scrap
    def self.perform(params = {}, &block)
      new(params).send(:call, &block)
    end

    private

    def initialize(params = {})
      @params = params
    end

    def call
      response        = HTTParty.get(params)
      body            = response.body
      doc             = Nokogiri::HTML(body)
      title           = doc.css('h1#firstHeading').text.strip
      languages       = doc.css('.interlanguage-link a').map { |link| link.children.text }
      clean_languages = languages.join(', ')

      {
        title: title,
        languages: clean_languages
      }
    end

    attr_reader :params
  end
end
