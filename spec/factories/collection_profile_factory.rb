# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  trait :collection_profile_indices do
    container nil
    otu nil
    # collection_type 'dry | wet | slide'
    conservation_status 3
    processing_state 3
    container_condition 3
    condition_of_labels 3
    identification_level 3
    arrangement_level 3
    data_quality 3
    computerization_level 3
    number_of_collection_objects 1
    number_of_containers nil
  end

  factory :collection_profile, traits: [:housekeeping, :collection_profile_indices] do

    factory :dry_collection_profile, aliases: [:valid_collection_profile] do
      collection_type 'dry'
    end
    factory :wet_collection_profile do
      collection_type 'wet'
    end
    factory :slide_collection_profile do
      collection_type 'slide'
    end
  end
end
