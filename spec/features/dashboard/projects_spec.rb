require 'spec_helper'

describe 'Dashboard::Projects', type: :feature do
  before { skip_auth_feature(DashboardController) }

  context 'empty' do
    before do
      stub_projects
      visit root_path
    end
    
    specify { expect(page).to have_content t('dashboard.empty.title') }
    specify { expect(page).to have_content t('dashboard.empty.subtitle') }
  end

  context 'projects' do
    let(:projects) { (1..5).map { |i| init_object(project_params) }}
    let(:project)  { projects.first }

    before do
      stub_projects(projects)
      stub_stories(project)
      visit root_path
    end

    specify { expect(project_nodes.size).to eq 5}
    specify { expect(story_nodes.size).to eq 10}
    specify { expect(page).to have_content project.name }
    specify { expect(page).to have_content "Averaged over #{project.velocity_averaged_over} weeks" }
    specify { expect(page).to have_content project.label_list.split(',').join(',') }

    specify { expect(page).to have_content project.point_scale.split(',').join(', ') }
  end

end