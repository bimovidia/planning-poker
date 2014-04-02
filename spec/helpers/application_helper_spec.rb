require 'spec_helper'

describe ApplicationHelper do
  
  context '#layout_class' do
    it 'should return authenticated' do
      helper.stubs(:user_signed_in?).returns(true)
      helper.layout_class.should eq 'authenticated'
    end

    it 'should return unauthenticated' do
      helper.stubs(:user_signed_in?).returns(false)
      helper.layout_class.should eq 'unauthenticated'
    end
  end

  context '#comma_separated' do
    it 'should return comma separated words' do
      helper.comma_separated((1..5).to_a).should eq '1, 2, 3, 4, 5'
    end
  end
end