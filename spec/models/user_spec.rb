require 'spec_helper'

describe User do
  let(:username)  { Forgery(:internet).email_address }
  let(:password)  { 'password' }

  let(:params) {{
    username: username,
    password: password
  }}

  let(:user) { FactoryBot.create(:user) }

  describe '.class' do

    context '#authenticate' do
      before { User.stubs(:create).returns(user) }
      
      it 'should return nil' do
        User.authenticate({}).should be_nil
      end

      it 'should call find_by on User' do
        User.expects(:find_by).with(
          username: params[:username]
        )

        User.authenticate(params)
      end

      it 'should return user' do
        User.authenticate(params).should eq user
      end

      it 'should create user' do
        user.delete
        User.expects(:create).with(params)
        User.authenticate(params)
      end
    end

    context '#create' do
      before do
        PivotalTracker::Client.stubs(:token).returns(user.token)
        User.stubs(:salted).returns(user.salt)
      end

      after  { User.create(params) }

      it 'should call token on PivotalTracker::Client' do
        PivotalTracker::Client.expects(:token).with(
          params[:username],
          params[:password]
        ).returns(user.token)
      end

      it 'should call salted' do
        User.expects(:salted).with(params[:username])
      end

      it 'should call new' do
        User.expects(:new).with(params.merge(token: user.token)).returns(user)
      end

      it 'should call save' do
        User.any_instance.expects(:save)
      end
    end
  end
end