require 'rails_helper'

RSpec.describe WikiController, type: :request do
  describe 'GET #index' do
    context 'when the query parameter is a valid Wikipedia URL' do
      let(:valid_url) { 'https://en.wikipedia.org/wiki/John_Doe' }

      before do
        allow(Wiki::Scrap).to receive(:perform).and_return({ title: 'John Doe', languages: 'English, Spanish' })
        get '/', params: { query: valid_url }
      end

      it 'calls the Wiki::Scrap.perform method' do
        expect(Wiki::Scrap).to have_received(:perform)
      end

      it 'renders the wiki/result partial' do
        expect(response).to render_template(partial: 'wiki/_result')
      end

      it 'assigns the expected title' do
        expect(assigns(:title)).to eq('John Doe')
      end

      it 'assigns the expected languages' do
        expect(assigns(:languages)).to eq('English, Spanish')
      end
    end

    context 'when the query parameter is not a valid Wikipedia URL' do
      let(:invalid_url) { 'https://notwikipedia.org/wiki/John_Doe' }

      before do
        allow(Wiki::Scrap).to receive(:perform)
        get '/', params: { query: invalid_url }
      end

      it 'does not call the Wiki::Scrap.perform method' do
        expect(Wiki::Scrap).not_to have_received(:perform)
      end
    end
  end
end
