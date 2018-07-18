require 'spec_helper'

describe User, type: :model do
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
        expect(User.authenticate({})).to be_nil
      end

      it 'should call find_by on User' do
        User.expects(:where).with(
          username: params[:username]
        ).returns([ user ])
        user.stubs(:authenticated?)

        User.authenticate(params)
      end

      it 'should return user' do
        expect(User.authenticate(params)).to eq user
      end

      it 'should create user' do
        user.delete
        User.expects(:create).with(params)
        User.authenticate(params)
      end
    end

    context '#create' do
      let(:fake_response) { mock }
      before do
        JSON.stubs(:parse).with(fake_response).returns({'api_token' => user.token})
        RestClient::Request.stubs(:execute).returns(fake_response)
        User.stubs(:salted).returns(user.salt)
      end

      after  { User.create(params) }

      it 'should call token on PivotalTracker::Client' do
        RestClient::Request.expects(:execute).returns(fake_response)
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