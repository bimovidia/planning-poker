require 'spec_helper'

describe DashboardHelper, type: :helper do
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
        expect(helper.icon(story)).to eq state[1]
      end
    end
  end

  context '#bar_icons' do
    it 'should return 10 bar icons' do
      expect(helper.bar_icons(10)).to eq('<span class="icon-bar"></span>' * 10)
    end
  end

  context '#show_estimation_icons?' do
    it 'should return true' do
      story.estimate = 5
      expect(helper.show_estimation_icons?(story)).to be true
    end

    it 'should return false' do
      story.estimate = 10
      expect(helper.show_estimation_icons?(story)).to be false
    end
  end

  context '#small_strong_text' do
    it 'should return small strong text' do
      expect(helper.small_strong_text('something')).to eq '<small><strong>something</strong></small>'
    end
  end

  context '#estimated?' do
    it 'should return true' do
      story.estimate = 5
      expect(helper.estimated?(story)).to be true
    end

    it 'should return false' do
      story.estimate = 0
      expect(helper.estimated?(story)).to be false
    end
  end

  context '#estimateable' do
    it 'should return true' do
      story.estimate = nil
      expect(helper.estimateable?(story)).to be true
    end

    it 'should return false' do
      story.estimate = 5
      expect(helper.estimateable?(story)).to be false
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
        expect(helper.state(story)).to eq "label label-#{state[1]} #{story.current_state}"
      end
    end
  end

  context '#card_class' do
    it 'should return card blank' do
      expect(helper.card_class(nil, true)).to eq 'card card-blank'
    end

    it 'should return card hidden' do
      expect(helper.card_class(false, true)).to eq 'card card-hidden'
    end

    it 'should return card reveal' do
      expect(helper.card_class(true, true)).to eq 'card card-revealed'
    end

    it 'should return card' do
      expect(helper.card_class(true, false)).to eq 'card'
    end
  end

  context '#method_missing' do
    ['accepted', 'delivered', 'rejected'].each do |state|
      it 'should return true' do
        story.current_state = state
        expect(helper.send("state_#{state}?", story)).to be true
      end

      it 'should return false' do
        story.current_state = 'somestate'
        expect(helper.send("state_#{state}?", story)).to be false
      end
    end

    ['feature', 'bug', 'chore'].each do |type|
      it 'should return true' do
        story.story_type = type
        expect(helper.send("type_#{type}?", story)).to be true
      end

      it 'should return false' do
        story.story_type = 'sometype'
        expect(helper.send("type_#{type}?", story)).to be false
      end
    end
  end

  context '#estimate_not_applicable?' do
    ['chore', 'bug'].each do |type|
      it 'should return true' do
        story.story_type = type
        expect(helper.estimate_not_applicable?(story)).to be true
      end
    end

    it 'should return false' do
      story_type = 'sometype'
      expect(helper.estimate_not_applicable?(story)).to be false
    end
  end

  context '#estimation_class' do
    it 'should return unestimateable' do
      helper.stubs(:type_chore?).returns(true)
      expect(helper.estimation_class(story)).to eq 'unestimateable'
    end

    it 'should return estimated' do
      helper.stubs(:type_chore?).returns(false)
      story.estimate = 5
      expect(helper.estimation_class(story)).to eq 'estimated'
    end

    it 'should return unestimated' do
      helper.stubs(:type_chore?).returns(false)
      story.estimate = -1
      expect(helper.estimation_class(story)).to eq 'unestimated'
    end
  end

  context '#nickname' do
    it 'should return first' do
      expect(helper.nickname('first.last@domain.com')).to eq 'first'
    end

    it 'should return name' do
      expect(helper.nickname('name@domain.com')).to eq 'name'
    end

    it 'should return nickname' do
      expect(helper.nickname('nickname')).to eq 'nickname'
    end
  end

  context '#vote' do
    before { helper.stubs(:current_user).returns('username' => 'username') }

    it 'should return vote' do
      vote.user = 'username'
      vote.vote = 5
      expect(helper.voting(vote)).to eq 5
    end

    it 'should return false' do
      vote.user = 'otheruser'
      expect(helper.voting(vote)).to be false
    end
  end

  context '#current_user_has_voted?' do
    before do
      helper.stubs(:current_user).returns('username' => 'username')
      Vote.stubs(:where).returns(vote)
    end
    
    it 'should call find_by on Vote' do
      story.id = 123
      Vote.expects(:where).with(story_id: 123, user: 'username')
      helper.current_user_has_voted?(story)
    end
    
    it 'should return true' do
      expect(helper.current_user_has_voted?(story)).to be true
    end
    
    it 'should return false' do
      Vote.stubs(:where).returns(nil)
      expect(helper.current_user_has_voted?(story)).to be false
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
      expect(helper.unestimateable?(story)).to be true
    end

    it 'should return false' do
      helper.stubs(:estimate_not_applicable?).returns(false)
      helper.stubs(:estimateable?).returns(true)
      expect(helper.unestimateable?(story)).to be false
    end
  end
end