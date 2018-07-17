require 'spec_helper'

describe 'Sessions::Logout', skip: true do
  before { skip_authentication(DashboardController) }

  context 'success' do
    before do
      stub_projects
      visit root_path
      logout
    end

    specify { page.should have_content t('flashes.sessions.destroy') }
  end

end