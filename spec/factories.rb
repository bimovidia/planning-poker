FactoryBot.define do

  factory :user do
    username  { Forgery::Internet.email_address }
    password  { Forgery::Basic.encrypt }
    salt      { Forgery::Basic.encrypt }
    token     { Forgery::Basic.encrypt }
  end

  factory :vote do
    user      Forgery::Internet.email_address
    story_id  Forgery::Basic.number(at_least: 1, at_most: 20)
    vote      Forgery::Basic.number(at_least: 1, at_most: 5)
  end

end