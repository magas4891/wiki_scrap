# frozen_string_literal: true

class WikiController < ApplicationController
  def index
    if params[:query]
      if wiki_url_validation(params[:query])
        data       = Wiki::Scrap.perform(params[:query])
        @title     = data[:title]
        @languages = data[:languages]

        render partial: 'wiki/result', locals: { title: @title, languages: @languages }
      end
    end
  end

  private

  def wiki_url_validation(url)
    parsed_url = URI.parse(url)

    parsed_url.host.include?('wikipedia')
  end
end
