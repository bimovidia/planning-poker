require 'spec_helper'

describe 'Sessions::Logout', type: :feature do
  before { skip_auth_feature(DashboardController) }

  context 'success' do
    before do
      stub_projects
      visit root_path
      logout
    end

    specify { expect(page).to have_content t('flashes.sessions.destroy') }
  end

end