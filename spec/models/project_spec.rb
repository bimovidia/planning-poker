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
            DateTime.stubs(:now).returns(DateTime.parse('3rd Feb 2001 04:05:06+03:30'))
            story1.stubs(:deadline).returns(DateTime.now - 3)
            story2.stubs(:deadline).returns(DateTime.now)
            story3.stubs(:deadline).returns(DateTime.now + 4)
            story4.stubs(:deadline).returns(nil)
            story5.stubs(:deadline).returns(nil)
            project.stubs(:stories).with(has_entry(:filter, 'story_type:release current_state:unscheduled')).returns([story4, story5])
            project.stubs(:stories).with(has_entry(:filter, 'story_type:release current_state:unstarted')).returns([story1, story2, story3])
        end
        it "returns a string" do
            retVal = Project.get_milestones(project)
            expect(retVal.is_a?(String)).to be true
        end
        it "returns milestones in a certain order and format" do
            retVal = Project.get_milestones(project)
            assert_equal retVal, "story2: 0 Day(s) Away\n\nstory3: 4 Day(s) Away\n\nstory1: -3 Day(s) Ago\n\nstory5: Unscheduled\n\nstory4: Unscheduled"
        end
    end
end
