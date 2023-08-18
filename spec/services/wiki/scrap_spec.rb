
require 'rails_helper'

RSpec.describe Wiki::Scrap do
  describe '.perform' do
    let(:wiki_url) { 'https://en.wikipedia.org/wiki/John_Doe' }
    let(:fake_response) do
      instance_double(HTTParty::Response,
                      body: "<html><h1 id='firstHeading'><span>John Doe</span></h1><li class='interlanguage-link'><a><span>English</span></a></li></html>")
    end

    let(:fake_doc) { instance_double(Nokogiri::HTML::Document) }

    before do
      allow(HTTParty).to receive(:get).and_return(fake_response)
      allow(Nokogiri::HTML).to receive(:parse).and_return(fake_doc)
      allow(fake_doc).to receive(:css).and_return([])
    end

    it 'makes a GET request to the provided URL' do
      described_class.perform(wiki_url)
      expect(HTTParty).to have_received(:get).with(wiki_url)
    end

    it 'parses the response body with Nokogiri' do
      result = described_class.perform(wiki_url)
      expect(result).to eq({ title: 'John Doe', languages: 'English' })
    end

    context 'when the response body contains a title and languages' do
      let(:title_node) { double('Node', text: 'John Doe') }
      let(:language_nodes) { [double('Node', children: double('Children', text: 'English'))] }

      before do
        allow(fake_doc).to receive(:css).with('h1#firstHeading').and_return([title_node])
        allow(fake_doc).to receive(:css).with('.interlanguage-link a').and_return(language_nodes)
      end

      it 'returns the title and languages from the response' do
        result = described_class.perform(wiki_url)
        expect(result).to eq({ title: 'John Doe', languages: 'English' })
      end
    end
  end
end