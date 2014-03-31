require 'spec_helper'

describe DashboardHelper do
  let(:story) { OpenStruct.new }
  let(:vote)  { OpenStruct.new }

  context '#icon' do
    [
      ['feature', 'fa fa-star orange'],
      ['bug', 'fa fa-bug red'],
      ['chore', 'fa fa-cog'],
      ['release', 'fa fa-flag-checkered green'],
      ['sometype', 'sometype']
    ].each do |state|
      it "should return #{state[0]} icon" do
        story.story_type = state[0]
        helper.icon(story).should eq state[1]
      end
    end
  end

  context '#bar_icons' do
    it 'should return 10 bar icons' do
      helper.bar_icons(10).should eq('<span class="icon-bar"></span>' * 10)
    end
  end

  context '#show_estimation_icons?' do
    it 'should return true' do
      story.estimate = 5
      helper.show_estimation_icons?(story).should be_true
    end

    it 'should return false' do
      story.estimate = 10
      helper.show_estimation_icons?(story).should be_false
    end
  end

  context '#small_strong_text' do
    it 'should return small strong text' do
      helper.small_strong_text('something').should eq '<small><strong>something</strong></small>'
    end
  end

  context '#estimated?' do
    it 'should return true' do
      story.estimate = 5
      helper.estimated?(story).should be_true
    end

    it 'should return false' do
      story.estimate = 0
      helper.estimated?(story).should be_false
    end
  end

  context '#estimateable' do
    it 'should return true' do
      story.estimate = -1
      helper.estimateable?(story).should be_true
    end

    it 'should return false' do
      story.estimate = 5
      helper.estimateable?(story).should be_false
    end
  end

  context '#state' do
    [
      ['accepted', 'success'],
      ['delivered', 'warning'],
      ['started', 'info'],
      ['rejected', 'danger'],
      ['somestate', 'default']
    ].each do |state|
      it 'should return accepter state' do
        story.current_state = state[0]
        helper.state(story).should eq "label label-#{state[1]} #{story.current_state}"
      end
    end
  end

  context '#card_class' do
    it 'should return card blank' do
      helper.card_class(nil, true).should eq 'card card-blank'
    end

    it 'should return card hidden' do
      helper.card_class(false, true).should eq 'card card-hidden'
    end

    it 'should return card reveal' do
      helper.card_class(true, true).should eq 'card card-revealed'
    end

    it 'should return card' do
      helper.card_class(true, false).should eq 'card'
    end
  end

  context '#method_missing' do
    ['accepted', 'delivered', 'rejected'].each do |state|
      it 'should return true' do
        story.current_state = state
        helper.send("state_#{state}?", story).should be_true
      end

      it 'should return false' do
        story.current_state = 'somestate'
        helper.send("state_#{state}?", story).should be_false
      end
    end

    ['feature', 'bug', 'chore'].each do |type|
      it 'should return true' do
        story.story_type = type
        helper.send("type_#{type}?", story).should be_true
      end

      it 'should return false' do
        story.story_type = 'sometype'
        helper.send("type_#{type}?", story).should be_false
      end
    end
  end

  context '#estimate_not_applicable?' do
    ['chore', 'bug'].each do |type|
      it 'should return true' do
        story.story_type = type
        helper.estimate_not_applicable?(story).should be_true
      end
    end

    it 'should return false' do
      story_type = 'sometype'
      helper.estimate_not_applicable?(story).should be_false
    end
  end

  context '#estimation_class' do
    it 'should return unestimateable' do
      helper.stubs(:type_chore?).returns(true)
      helper.estimation_class(story).should eq 'unestimateable'
    end

    it 'should return estimated' do
      helper.stubs(:type_chore?).returns(false)
      story.estimate = 5
      helper.estimation_class(story).should eq 'estimated'
    end

    it 'should return unestimated' do
      helper.stubs(:type_chore?).returns(false)
      story.estimate = -1
      helper.estimation_class(story).should eq 'unestimated'
    end
  end

  context '#nickname' do
    it 'should return first' do
      helper.nickname('first.last@domain.com').should eq 'first'
    end

    it 'should return name' do
      helper.nickname('name@domain.com').should eq 'name'
    end

    it 'should return nickname' do
      helper.nickname('nickname').should eq 'nickname'
    end
  end

  context '#vote' do
    before { helper.stubs(:current_user).returns(username: 'username') }

    it 'should return vote' do
      vote.user = 'username'
      vote.vote = 5
      helper.voting(vote).should eq 5
    end

    it 'should return false' do
      vote.user = 'otheruser'
      helper.voting(vote).should be_false
    end
  end

  context '#current_user_has_voted?' do
    before do
      helper.stubs(:current_user).returns(username: 'username')
      Vote.stubs(:find_by).returns(vote)
    end
    
    it 'should call find_by on Vote' do
      story.id = 123
      Vote.expects(:find_by).with(story_id: 123, user: 'username')
      helper.current_user_has_voted?(story)
    end
    
    it 'should return true' do
      helper.current_user_has_voted?(story).should be_true
    end
    
    it 'should return false' do
      Vote.stubs(:find_by).returns(nil)
      helper.current_user_has_voted?(story).should be_false
    end
  end

  context '#estimation' do
    before do
      helper.stubs(:estimated?).returns(true)
      story.estimate = 5
    end

    it 'should call bar icons' do
      helper.stubs(:show_estimation_icons?).returns(true)
      helper.expects(:bar_icons).with(story.estimate)
      helper.estimation(story)
    end

    it 'should call small strong text' do
      helper.stubs(:show_estimation_icons?).returns(false)
      helper.expects(:small_strong_text).with(story.estimate)
      helper.estimation(story)
    end
  end

  context '#unestimateable' do
    it 'should return true' do
      helper.stubs(:estimate_not_applicable?).returns(true)
      helper.stubs(:estimateable?).returns(false)
      helper.unestimateable?(story).should be_true
    end

    it 'should return false' do
      helper.stubs(:estimate_not_applicable?).returns(false)
      helper.stubs(:estimateable?).returns(true)
      helper.unestimateable?(story).should be_false
    end
  end
end