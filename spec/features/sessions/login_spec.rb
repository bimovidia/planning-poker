require 'spec_helper'

describe 'Sessions::Login', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  context 'success' do
    before do
      stub_user(user)
      @client = mock
      TrackerApi::Client.stubs(:new).returns(@client)
      stub_projects
      login
    end

    specify { expect(page).to have_content t('flashes.sessions.success') }
  end

  context 'failure' do
    before do
      stub_user
      @client = mock
      TrackerApi::Client.stubs(:new).returns(@client)
      stub_projects
    end

    context 'login' do
      before { login }

      specify { expect(current_path).to eq login_path }
      specify { expect(page).to have_content t('flashes.sessions.failed') }
    end
  end

end