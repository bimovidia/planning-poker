class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true, foreign_key: true
      t.references :vote, index: true, foreign_key: true
      t.integer :project_id
      t.integer :story_id
      t.string :activity_type
      t.text :activity_data

      t.timestamps null: false
    end
  end
end
