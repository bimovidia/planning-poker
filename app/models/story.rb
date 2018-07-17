class Story
  class << self

    def update(params, client)
      # story = client.project(params[:id].to_i).story(params[:story_id].to_i)
      story = client.project(params[:project_id].to_i).story(params[:story_id].to_i)
      story.estimate = params[:story][:estimate]
      story.save
    end

  end
end