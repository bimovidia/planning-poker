class DashboardController < ApplicationController
  before_action :require_authentication, :reset_token, :decode_user
  respond_to    :js

  def index
    @projects = PivotalTracker::Project.all
  end

  # Ajax
  def project
    @project = PivotalTracker::Project.find(params[:id].to_i)

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

protected

  def decode_user
    params[:user] = Base64.strict_decode64(params[:user]) if params and params[:user]
  end
end