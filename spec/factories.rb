FactoryGirl.define do

  factory :user do
    username  { Forgery(:internet).email_address }
    password  { Forgery(:basic).encrypt }
    salt      { Forgery(:basic).encrypt }
    token     { Forgery(:basic).encrypt }
  end

  factory :vote do
    user      Forgery(:internet).email_address
    story_id  Forgery(:basic).number(at_least: 1, at_most: 20)
    vote      Forgery(:basic).number(at_least: 1, at_most: 5)
  end

end