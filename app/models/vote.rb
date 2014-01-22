class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :story_id, type: Integer
  field :vote,     type: Integer
  field :user,     type: String

  class << self

    def set(params)
      vote = find_by(
        user:     params[:user],
        story_id: params[:story_id]
      )

      if vote
        vote.update(vote: params[:vote])
      else
        create(
          user:     params[:user],
          story_id: params[:story_id],
          vote:     params[:vote]
        )
      end
    end

    def reset(params)
      vote = find_by(
        user:     params[:user],
        story_id: params[:story_id]
      )

      vote.delete if vote
    end

  end
end
