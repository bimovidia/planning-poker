class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :vote, required: false
end
