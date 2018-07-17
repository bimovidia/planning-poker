require 'spec_helper'

describe 'Sessions::Exceptions', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  context 'unauthenticated' do
    before { visit root_path }

    specify { expect(current_path).to eq login_path }
    specify { expect(page).to have_content t('flashes.sessions.expired') }
  end

  # context 'no token' do
  #   before do
  #     RestClient::Request.stubs(:execute).raises(
  #       RestClient::Unauthorized
  #     )
  #
  #     login
  #   end
  #
  #   specify { page.should have_content t('flashes.sessions.token') }
  # end

  context 'rest client unauthorized' do
    before do
      skip_auth_feature(DashboardController)


      @client.stubs(:projects).raises(
          TrackerApi::Errors::ClientError.new(OpenStruct.new)
      )

      visit root_path
    end

    specify { expect(current_path).to eq login_path }
    specify { expect(page).to have_content t('flashes.sessions.unauthorized') }
  end

end