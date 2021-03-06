# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :otu_content, traits: [:housekeeping] do
    factory :valid_otu_content do
      association :otu,   factory: :valid_otu
      association :topic, factory: :valid_topic
      text "MyText"
    end
  end
end
