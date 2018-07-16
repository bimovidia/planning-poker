class Story
  class << self

    def update(params)
      story = TrackerApi::Resources::Story.new( client:     params[:client],
                                                project_id: params[:project_id],
                                                id:         params[:story_id])
      story.attributes = params[:story]
      story.save
    end

  end
end