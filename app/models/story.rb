class Story
  class << self

    def update(params)
      story = params[:client].project(params[:project_id].to_i).story(params[:story_id].to_i)
      story.estimate = params[:story][:estimate]
      story.name = params[:story][:name]
      story.description = params[:story][:description]
      story.save
    end

  end
end