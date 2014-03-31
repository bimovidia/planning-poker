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
end