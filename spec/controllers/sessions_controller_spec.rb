require 'spec_helper'

describe SessionsController, type: :controller do

  let(:user) { FactoryBot.build(:user) }

  before do
    SessionsController.any_instance.stubs(:user_signed_in?).returns(true)
  end

  def valid_session
    {}
  end

  describe 'GET new' do

    it 'should redirect to root' do
      get :new, {}, valid_session
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST create' do
    let(:params) {{
      'username' => user.username,
      'password' => user.password
    }}
    
    context 'user exist' do
      before { User.stubs(:authenticate).returns(user) }

      it 'should call authenticate on User' do
        User.expects(:authenticate).with(params)
        post :create, params, valid_session
      end

      it 'should set user session' do
        post :create, params, valid_session
        expect(session[:user]).to eq({ username: user.username, token: user.token })
      end

      it 'should redirect to root' do
        post :create, params, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before { User.stubs(:authenticate).returns(nil) }

      it 'should redirect to login path' do
        post :create, params, valid_session
        expect(response).to redirect_to login_path
      end

    end
  end

  describe 'DELETE destroy' do
    before do
      session[:user] = { 
        username: user.username,
        token:    user.token
      }
    end

    it 'should reset session' do
      delete :destroy, {}, valid_session
      expect(session).not_to have_key(:user)
    end

    it 'should redirect to login' do
      delete :destroy, {}, valid_session
      expect(response).to redirect_to login_path
    end
  end

end