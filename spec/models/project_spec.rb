require 'spec_helper'

describe Project, type: :model do
    before do
        Project.delete_all
        $service = mock("$service")
        $service.stubs(:insert_event).returns({:id => "abcd"})
    end
    let(:project_id) { "some_id" }
    context "#create_hangout" do
        it "runs event create process on a new thread" do
            Thread.expects(:new)
            Project.create_hangout(:project_id)
        end
        it "locks before calling API" do
            Project.any_instance.expects(:event_id=).with("LOCKED")
            Project.create_hangout(:project_id)
        end
        it "creates new project with event" do
            Project.create_hangout(project_id)
            assert_equal Project.all.count, 1
            assert_equal Project.all.first.pivotal_id, project_id
        end
    end

    context "#get_milestones" do
        let(:project) { mock('project') }
        before do
            story1 = mock("story1")
            story2 = mock("story2")
            story3 = mock("story3")
            story4 = mock("story4")
            story5 = mock("story5")
            story1.stubs(:name).returns("story1")
            story2.stubs(:name).returns("story2")
            story3.stubs(:name).returns("story3")
            story4.stubs(:name).returns("story4")
            story5.stubs(:name).returns("story5")
            story1.stubs(:deadline).returns("deadline1")
            story2.stubs(:deadline).returns("deadline2")
            story3.stubs(:deadline).returns("deadline3")
            project.stubs(:stories).with(has_entry(:filter, 'story_type:release current_state:unscheduled')).returns([story4, story5])
            project.stubs(:stories).with(has_entry(:filter, 'story_type:release current_state:unstarted')).returns([story1, story2, story3])
        end
        it "returns a string" do
            retVal = Project.get_milestones(project)
            expect(retVal.is_a?(String)).to be true
        end
        it "returns milestones in a certain order and format" do
            retVal = Project.get_milestones(project)
            assert_equal retVal, "story1: deadline1\nstory2: deadline2\nstory3: deadline3\nstory4\nstory5"
        end
    end
end
