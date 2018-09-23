require 'spec_helper'

describe DashboardController, type: :controller do

  before do
    skip_authentication(DashboardController)
  end

  def valid_session
    {}
  end

  describe 'GET index' do
    before { @client.stubs(:projects) }

    it 'should call all on PivotalTracker::Project' do
      @client.expects(:projects)
      get :index, {}, valid_session
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({user_id: user.id, activity_type: 'dashboard#index'})
      get :index, {}, valid_session
    end
  end

  describe 'GET project' do
    before { @client.stubs(:project) }
    let(:params) {{ id: 1 }}

    it 'should call find on PivotalTracker::Project' do
      @client.expects(:project).with(params[:id])
      xhr :get, :project, params, valid_session, format: :js
    end

    it 'should render ajax project' do
      xhr :get, :project, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/project'
    end

    it 'should create  an acvitiy' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#project',
                    project_id: params[:id]
                })
      xhr :get, :project, params, valid_session, format: :js
    end
  end

  describe 'GET vote' do
    before { Vote.stubs(:set) }

    let(:params) {{
        'story_id'   => '123',
        'vote'       => '1',
        'user'       => encoded_user,
        'controller' => 'dashboard',
        'action'     => 'vote'
    }}

    it 'should call set of Vote' do
      Vote.expects(:set).with(params.merge('user' => decoded_user(params['user'])))
      xhr :get, :vote, params, valid_session, format: :js
    end

    it 'should assign resource' do
      xhr :get, :vote, params, valid_session, format: :js
      expect(assigns(:resource)).to eq({ story_id: params['story_id'], vote: params['vote'], user: decoded_user(params['user']) })
    end

    it 'should render ajax set' do
      xhr :get, :vote, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/vote'
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#vote',
                    story_id: '123',
                    activity_data: {
                        story_id: '123',
                        vote: '1',
                        user: decoded_user(params['user'])
                    }.to_json
                })
      xhr :get, :vote, params, valid_session, format: :js
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
      expect(assigns(:resource)).to eq({ story_id: params['story_id'], user: decoded_user(params['user']) })
    end

    it 'should render ajax reset' do
      xhr :get, :reset, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/reset'
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#reset',
                    story_id: '123',
                    activity_data: {story_id: '123', user: decoded_user(params['user'])}.to_json
                })
      xhr :get, :reset, params, valid_session, format: :js
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
      expect(assigns(:resource)).to eq params.merge(user: decoded_user(params[:user]))
    end

    it 'should render ajax detail' do
      xhr :get, :detail, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/detail'
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#detail',
                    story_id: '123',
                    activity_data: {
                        story_id: '123',
                        toggle: 'dashboard',
                        user: decoded_user(params[:user])
                    }.to_json
                })
      xhr :get, :detail, params, valid_session, format: :js
    end
  end

  describe 'GET reveal' do
    let(:params) {{ 
      story_id: '123'
    }}

    it 'should assign resource' do
      xhr :get, :reveal, params, valid_session, format: :js
      expect(assigns(:resource)).to eq params
    end

    it 'should render ajax reveal' do
      xhr :get, :reveal, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/reveal'
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#reveal',
                    story_id: '123',
                    activity_data: {story_id: '123'}.to_json
                })
      xhr :get, :reveal, params, valid_session, format: :js
    end
  end

  describe "GET discussion" do
    let(:params) {{ 
      story_id: '123'
    }}

    it "should render ajax discussion" do
      xhr :get, :discussion, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/discussion'
    end
  end

  describe 'POST update' do
    let(:params) {{
      'id'         => '1',
      'controller' => 'dashboard',
      'action'     => 'update'
    }}
    let(:fake_return) { story_params.update({id: '1'}) }

    before { Story.stubs(:update).returns(fake_return) }

    it 'should call update on Story' do
      params['client'] = @client
      Story.expects(:update).with(params)
      xhr :post, :update, params, valid_session, format: :js
    end

    it 'should render ajax update' do
      xhr :post, :update, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/update'
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#update',
                    story_id: '1',
                    activity_data: fake_return.to_json
                })
      xhr :post, :update, params, valid_session, format: :js
    end
  end

  describe 'POST select' do
    let(:params) {{
      story_id: '123',
      username: 'username'
    }}

    it 'should assign resource' do
      xhr :post, :select, params, valid_session, format: :js
      expect(assigns(:resource)).to eq params
    end

    it 'should render ajax select' do
      xhr :post, :select, params, valid_session, format: :js
      expect(response).to render_template 'dashboard/ajax/select'
    end

    it 'should create an activity' do
      Activity.expects(:create)
          .with({
                    user_id: user.id,
                    activity_type: 'dashboard#select',
                    story_id: '123',
                    activity_data: {story_id: '123', username: 'username'}.to_json
                })
      xhr :post, :select, params, valid_session, format: :js
    end
  end

  describe "GET get_hangouts_link" do
    let(:params) {{
      project_id: 1,
    }}

    before do
      $service = mock("$service")
      $service.stubs(:insert_event).returns({:id => "abcd"})
      end

    it "should call on Project#create_hangout" do
      Project.expects(:create_hangout)
      get :get_hangouts_link, params, valid_session
    end
    it "should redirect to correct page after starting process" do
      get :get_hangouts_link, params, valid_session
      expect(response).to redirect_to :root
    end
  end

end