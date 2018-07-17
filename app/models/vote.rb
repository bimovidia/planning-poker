class Vote < ActiveRecord::Base
  class << self

    def set(params)
      vote = Vote.where(
        user:     params[:user],
        story_id: params[:story_id]
      ).take

      if vote
        vote.update(:vote => params[:vote].to_i)
      else
        create(
          user:     params[:user],
          story_id: params[:story_id],
          vote:     params[:vote]
        )
      end
    end

    def reset(params)
      vote = Vote.where(
        user:     params[:user],
        story_id: params[:story_id]
      ).take

      vote.destroy if vote
    end

  end
end
