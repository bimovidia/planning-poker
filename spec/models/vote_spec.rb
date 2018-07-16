require 'spec_helper'

describe Vote do
  let(:vote) { FactoryBot.create(:vote) }

  describe '.class' do

    context '#set' do
      let(:params) {{
        user:     vote.user,
        story_id: vote.story_id,
        vote:     Forgery(:basic).number(at_least: 1, at_most: 5)
      }}

      after { Vote.set(params) }

      it 'should call find_by on Vote' do
        Vote.expects(:find_by).with(
          user:     params[:user],
          story_id: params[:story_id]
        )
      end

      it 'should call update on vote instance' do
        Vote.any_instance.expects(:update).with(
          vote: params[:vote]
        )
      end

      it 'should create vote' do
        vote.destroy
        Vote.expects(:create).with(
          user:     params[:user],
          story_id: params[:story_id],
          vote:     params[:vote]
        )
      end
    end

    context '#reset' do
      let(:params) {{
        user:     vote.user,
        story_id: vote.story_id,
      }}

      after { Vote.reset(params) }

      it 'should call find_by on Vote' do
        Vote.expects(:find_by).with(
          user:     params[:user],
          story_id: params[:story_id]
        )
      end

      it 'should call delete on vote instance' do
        Vote.any_instance.expects(:delete)
      end
    end

  end
end