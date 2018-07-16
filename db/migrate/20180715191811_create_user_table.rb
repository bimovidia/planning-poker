class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
        t.string :username
        t.string :password
        t.string :salt
        t.string :token
    end
  end
end
