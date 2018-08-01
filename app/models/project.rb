class Project < ActiveRecord::Base
    def self.getHangoutJoinIcon(project)
        event_id = Project.where(pivotal_id: project.id.to_s).first.event_id
        result = $service.get_event("berkeley.edu_9f5b4e17egep4l9e0birqr8pu4@group.calendar.google.com", event_id)
        return [result.conference_data.conference_solution.icon_uri, result.hangout_link]
    end
end
