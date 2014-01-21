class Story
  class << self

    def update(params)
      story = PivotalTracker::Story.find(
        params[:story_id],
        params[:project_id]
      )

      story.update(params[:story])
    end

  end
end