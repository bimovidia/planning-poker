class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
        t.integer :story_id
        t.integer :vote
        t.string :user
    end
  end
end
