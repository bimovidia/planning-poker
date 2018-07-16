require 'spec_helper'

describe 'Sessions::Login' do
  let(:user) { FactoryBot.create(:user) }

  context 'success' do
    before do
      stub_user(user)
      stub_projects
      login
    end

    specify { page.should have_content t('flashes.sessions.success') }
  end

  context 'failure' do
    before do
      stub_user
      stub_projects
    end

    context 'login' do
      before { login }

      specify { current_path.should eq login_path }
      specify { page.should have_content t('flashes.sessions.failed') }
    end
  end

end