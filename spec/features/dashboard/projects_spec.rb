require 'spec_helper'

describe 'Dashboard::Projects' do
  before { skip_authentication(DashboardController) }

  context 'empty' do
    before do
      stub_projects
      visit root_path
    end
    
    specify { page.should have_content t('dashboard.empty.title') }
    specify { page.should have_content t('dashboard.empty.subtitle') }
  end

  context 'projects' do
    let(:projects) { (1..5).map { |i| init_object(project_params) }}
    let(:project)  { projects.first }

    before do
      stub_projects(projects)
      stub_stories(project)
      visit root_path
    end

    specify { project_nodes.size.should eq 5}
    specify { story_nodes.size.should eq 10}
    specify { page.should have_content project.name }
    specify { page.should have_content project.velocity_scheme }
    specify { page.should have_content project.labels.split(',').join(', ') }
    specify { page.should have_content project.point_scale.split(',').join(', ') }
  end

end