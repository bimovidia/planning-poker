require 'spec_helper'

describe 'Dashboard::Projects', type: :feature do
    before { skip_auth_feature(DashboardController) }
    context 'no hangout' do
        let(:projects) { (1..5).map { |i| init_object(project_params) }}
        let(:project)  { projects.first }
        before do
            Project.delete_all
            stub_projects(projects)
            stub_stories(project)
            visit root_path
        end

        specify { expect(page).to have_link "Click here to create Google Hangouts meeting.", href: makehangout_path(:project_id => project.id) }
    end

    context "hangout being made" do
        let(:projects) { (1..5).map { |i| init_object(project_params) }}
        let(:project)  { projects.first }
        before do
            Project.delete_all
            p = Project.new({pivotal_id: project.id, event_id: "LOCKED"})
            p.save!
            stub_projects(projects)
            stub_stories(project)
            visit root_path
        end

        specify { expect(page).to have_text "Creating Google Hangouts session. Please wait and then refresh your page later." }
    end

    context "hangouts already made" do
        let(:projects) { (1..5).map { |i| init_object(project_params) }}
        let(:project)  { projects.first }
        before do
            Project.delete_all
            p = Project.new({pivotal_id: project.id, event_id: "12345"})
            p.save!
            $service = mock("$service")
            obj = OpenStruct.new
            obj.hangout_link = "abcd.com"
            obj.conference_data = OpenStruct.new
            obj.conference_data.conference_solution = OpenStruct.new
            obj.conference_data.conference_solution.icon_uri = "efgh.com"
            $service.stubs(:get_event).returns(obj)
            stub_projects(projects)
            stub_stories(project)
            visit root_path
        end

        specify { expect(page).to have_link nil, href: "abcd.com" }

    end
end