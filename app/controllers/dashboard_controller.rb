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
  end

  # Ajax
  def project
    @project = @client.project(params[:id].to_i)

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

  def getHangoutsLink
    query = Project.where(pivotal_id: params[:project_id].to_s)
    if (!query.any?) 
      proj = Project.new
      proj.pivotal_id = params[:project_id].to_s
      proj.event_id = "LOCKED"
      proj.save!
      thr = Thread.new {
        event = Google::Apis::CalendarV3::Event.new({
          summary: 'Planning Poker Meeting',
          start: {
            date_time: Time.now.iso8601,
            time_zone: 'America/Los_Angeles',
          },
          end: {
            date_time: (Time.now + 120*60).iso8601,
            time_zone: 'America/Los_Angeles',
          },
          conference_data: {
            create_request: {request_id: (0...8).map { ('a'..'z').to_a[rand(26)] }.join}
          }
        })

        $service.request_options.retries = 5
        result = $service.insert_event($calendar_id, event, conference_data_version: 1)

        proj.event_id = result.id
        proj.save!
      }
    end
    redirect_to "/"
  end

protected

  def decode_user
    params[:user] = Base64.strict_decode64(params[:user]) if params and params[:user]
  end
end