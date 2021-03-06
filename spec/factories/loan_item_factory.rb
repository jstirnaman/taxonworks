# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :loan_item do
    loan nil
    collection_object nil
    date_returned "2014-02-26"
    collection_object_status "MyString"
    position 1
    created_by_id 1
    updated_by_id 1
    project_id 1

    factory :second_loan_item, aliases: [:valid_loan_item] do

    end
  end
end
