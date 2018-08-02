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
end
