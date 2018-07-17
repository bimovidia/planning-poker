require 'spec_helper'

describe Story, type: :model do

  context '.class' do

    context '#update' do
      let(:client) { mock('client') }
      let(:project) { mock('project') }
      let(:story) { OpenStruct.new }

      let(:params) {{
        story:      {
            estimate: 1,
            name: 'fake name',
            description: 'fake description'
        },
        story_id:   123,
        project_id: 312,
        client: client
      }}

      before do
        client.stubs(:project).returns(project)
        project.stubs(:story).returns(story)
        %I[estimate name description save].each do |kwd|
          story.stubs(kwd).returns(OpenStruct.new)
        end
      end

      it 'should call find on PivotalTracker::Story' do
        client.expects(:project).with(params[:project_id]).returns(project)
        project.expects(:story).with(params[:story_id]).returns(story)
        
        Story.update(params)
      end

      it 'should call update on story' do
        story.expects(:save)
        Story.update(params)
      end
    end

  end
end