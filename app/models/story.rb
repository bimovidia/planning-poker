class Story
  class << self

    def update(params)
      story = User.client.project(params[:id].to_i).story(params[:story_id].to_i)
      story.update(params[:story])
    end

  end
end