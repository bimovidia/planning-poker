require 'spec_helper'

describe ApplicationHelper, type: :helper do
  
  context '#layout_class' do
    it 'should return authenticated' do
      helper.stubs(:user_signed_in?).returns(true)
      expect(helper.layout_class).to eq 'authenticated'
    end

    it 'should return unauthenticated' do
      helper.stubs(:user_signed_in?).returns(false)
      expect(helper.layout_class).to eq 'unauthenticated'
    end
  end

  context '#comma_separated' do
    it 'should return comma separated words' do
      expect(helper.comma_separated((1..5).to_a)).to eq '1, 2, 3, 4, 5'
    end
  end
end