class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|

      t.timestamps null: false
      t.string :pivotal_id
      t.string :event_id
    end
  end
end
