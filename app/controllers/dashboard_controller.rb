require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Teamscope-planning-poker'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

class DashboardController < ApplicationController
  before_action :require_authentication, :reset_token, :decode_user
  respond_to    :js
  protect_from_forgery except: :reveal

  # initialize Google API for Hangout Meetings
  $service = Google::Apis::CalendarV3::CalendarService.new
  $service.client_options.application_name = APPLICATION_NAME
  $service.authorization = authorize
  $calendar_id = "berkeley.edu_9f5b4e17egep4l9e0birqr8pu4@group.calendar.google.com"

  def index
    @projects = @client.projects
    if session[:last_project] && @projects && !@projects.empty?
      curr_proj = @client.project(session[:last_project])
      @projects.unshift @projects.delete(curr_proj)
    end
  end

  # Ajax
  def project
    @project = @client.project(params[:id].to_i)
    session[:last_project] = params[:id].to_i
    respond_with @project do |format|
      format.js { render 'dashboard/ajax/project' }
    end
  end

  def vote
    Vote.set(params)

    @resource = {
      story_id: params[:story_id],
      vote:     params[:vote],
      user:     params[:user]
    }

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/vote' }
    end
  end

  def reset
    Vote.reset(params)

    @resource = {
      story_id: params[:story_id],
      user:     params[:user]
    }

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/reset' }
    end
  end

  def detail
    @resource = {
      story_id: params[:story_id],
      toggle:   params[:toggle],
      user:     params[:user]
    }

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/detail' }
    end
  end

  def reveal
    @resource = {
      story_id: params[:story_id]
    }

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/reveal' }
    end
  end

  def discussion
    @resource = {
      story_id: params[:story_id]
    }

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/discussion' }
    end
  end

  def update
    params[:client] = @client
    @resource = Story.update(params)

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/update' }
    end
  end

  def select
    @resource = {
      story_id: params[:story_id],
      username: params[:username]
    }

    respond_with @resource do |format|
      format.js { render 'dashboard/ajax/select' }
    end
  end

  def get_hangouts_link
    Project.create_hangout(params[:project_id])
    redirect_to root_path
  end


protected

  def decode_user
    params[:user] = Base64.strict_decode64(params[:user]) if params and params[:user]
  end
end