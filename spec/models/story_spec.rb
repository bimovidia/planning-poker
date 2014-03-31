require 'spec_helper'

describe Story do

  context '.class' do

    context '#update' do
      let(:story) { OpenStruct.new }

      let(:params) {{
        story:      'story',
        story_id:   123,
        project_id: 312
      }}

      before do
        PivotalTracker::Story.stubs(:find).returns(story)
        story.stubs(:update)
      end

      it 'should call find on PivotalTracker::Story' do
        PivotalTracker::Story.expects(:find).with(
          params[:story_id], params[:project_id]
        ).returns(story)
        
        Story.update(params)
      end

      it 'should call update on story' do
        story.expects(:update).with(params[:story])
        Story.update(params)
      end
    end

  end
end