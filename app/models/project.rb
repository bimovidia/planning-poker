class Project < ActiveRecord::Base
    def self.get_hangout_join_icon(project)
        event_id = Project.where(pivotal_id: project.id.to_s).first.event_id
        result = $service.get_event($calendar_id, event_id)
        return [result.conference_data.conference_solution.icon_uri, result.hangout_link]
    end

    def self.create_hangout(project_id)
        query = Project.where(pivotal_id: project_id.to_s)
        if (!query.any?) 
          proj = Project.new
          proj.pivotal_id = project_id.to_s
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
    end

    def self.get_milestones(project)
      unplanned = project.stories(filter: 'story_type:release current_state:unscheduled')
      unstarted = project.stories(filter: 'story_type:release current_state:unstarted')

      #Find release date for unstarted
      deadlines = unstarted.map(&:deadline)
      unstarted = unstarted.map(&:name)
      unstarted_deadlines = unstarted.zip(deadlines)

      unplanned = unplanned.map(&:name)

      unstarted_deadlines_appended = []
      for pair in unstarted_deadlines
        unstarted_deadlines_appended << pair.join(": ")
      end

      retVal = unstarted_deadlines_appended.join("\n")
      retVal += "\n"
      retVal += unplanned.join("\n")
      return retVal
    end
end
