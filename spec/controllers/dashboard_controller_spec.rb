require 'spec_helper'

describe DashboardController do

  before do
    skip_authentication(DashboardController)
  end

  def valid_session
    {}
  end

  describe 'GET index' do
    before { PivotalTracker::Project.stubs(:all) }

    it 'should call all on PivotalTracker::Project' do
      PivotalTracker::Project.expects(:all)
      get :index, {}, valid_session
    end
  end

  describe 'GET project' do
    before { PivotalTracker::Project.stubs(:find) }
    let(:params) {{ id: 1 }}

    it 'should call find on PivotalTracker::Project' do
      PivotalTracker::Project.expects(:find).with(params[:id])
      xhr :get, :project, params, valid_session, format: :js
    end

    it 'should render ajax project' do
      xhr :get, :project, params, valid_session, format: :js
      response.should render_template 'dashboard/ajax/project'
    end
  end

  describe 'GET reset' do
    before { Vote.stubs(:reset) }

    let(:params) {{ 
      'story_id'   => '123',
      'user'       => encoded_user,
      'controller' => 'dashboard',
      'action'     => 'reset'
    }}

    it 'should call reset on Vote' do
      Vote.expects(:reset).with(params.merge('user' => decoded_user(params['user'])))
      xhr :get, :reset, params, valid_session, format: :js
    end

    it 'should assign resource' do
      xhr :get, :reset, params, valid_session, format: :js
      assigns(:resource).should eq({ story_id: params['story_id'], user: decoded_user(params['user']) })
    end

    it 'should render ajax reset' do
      xhr :get, :reset, params, valid_session, format: :js
      response.should render_template 'dashboard/ajax/reset'
    end
  end

  describe 'GET detail' do
    let(:params) {{
      story_id: '123',
      toggle:   'dashboard',
      user:     encoded_user
    }}

    it 'should assign resource' do
      xhr :get, :detail, params, valid_session, format: :js
      assigns(:resource).should eq params.merge(user: decoded_user(params[:user]))
    end

    it 'should render ajax detail' do
      xhr :get, :detail, params, valid_session, format: :js
      response.should render_template 'dashboard/ajax/detail'
    end
  end

  describe 'GET reveal' do
    let(:params) {{ 
      story_id: '123'
    }}

    it 'should assign resource' do
      xhr :get, :reveal, params, valid_session, format: :js
      assigns(:resource).should eq params
    end

    it 'should render ajax reveal' do
      xhr :get, :reveal, params, valid_session, format: :js
      response.should render_template 'dashboard/ajax/reveal'
    end
  end

  describe 'POST update' do
    let(:params) {{
      'id'         => '1',
      'controller' => 'dashboard',
      'action'     => 'update'
    }}

    before { Story.stubs(:update) }

    it 'should call update on Story' do
      Story.expects(:update).with(params)
      xhr :post, :update, params, valid_session, format: :js
    end

    it 'should render ajax update' do
      xhr :post, :update, params, valid_session, format: :js
      response.should render_template 'dashboard/ajax/update'
    end
  end

  describe 'POST select' do
    let(:params) {{
      story_id: '123',
      username: 'username'
    }}

    it 'should assign resource' do
      xhr :post, :select, params, valid_session, format: :js
      assigns(:resource).should eq params
    end

    it 'should render ajax select' do
      xhr :post, :select, params, valid_session, format: :js
      response.should render_template 'dashboard/ajax/select'
    end
  end

end