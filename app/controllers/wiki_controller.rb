# frozen_string_literal: true

class WikiController < ApplicationController
  def index
    if params[:query] && valid_wiki_page?(params[:query])
      data       = Wiki::Scrap.perform(params[:query])
      @title     = data[:title]
      @languages = data[:languages]

      render partial: 'wiki/result', locals: { title: @title, languages: @languages }
    end
  end

  private

  def valid_wiki_page?(url)
    parsed_url = URI.parse(url)

    parsed_url.class.to_s.eql?('URI::HTTPS') && parsed_url.host.include?('.wikipedia.')
  end
end
