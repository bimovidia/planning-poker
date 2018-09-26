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

      # Combine unplanned and unstarted
      total_milestones = unplanned + unstarted

      milestone_names = total_milestones.map(&:name)
      milestone_deadlines = total_milestones.map(&:deadline)
      # print(milestoned_dateeadlines)
      milestone_deadlines = milestone_deadlines.map do |e| 
        if (not e)
          nil
        else
          BigDecimal.new(((e - DateTime.now)), 0).round(0, :up).to_i
        end
      end

      name_deadline = milestone_names.zip(milestone_deadlines)
      unstarted_deadlines = name_deadline.sort do |a, b| 
        if (a[1] == nil)
          1
        elsif (b[1] == nil)
          -1
        else
          a[1] <=> b[1]
        end
      end



      unstarted_deadlines_appended_future = []
      unstarted_deadlines_appended_past = []
      unstarted_deadlines_appended_undef = []
      for pair in unstarted_deadlines
        if (pair[1] == nil)
          unstarted_deadlines_appended_undef << pair[0] + ": " + "Unscheduled"
        elsif (pair[1] < 0)
          unstarted_deadlines_appended_past << pair.join(": ") + " Day(s) Ago"
        else
          unstarted_deadlines_appended_future << pair.join(": ") + " Day(s) Away"
        end
      end

      retVal = unstarted_deadlines_appended_future.join("\n\n")
      retVal += "\n\n"
      retVal += unstarted_deadlines_appended_past.reverse.join("\n\n")
      retVal += "\n\n"
      retVal += unstarted_deadlines_appended_undef.join("\n\n")
      return retVal
    end
end
