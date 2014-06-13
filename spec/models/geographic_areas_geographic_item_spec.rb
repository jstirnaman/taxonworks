require 'spec_helper'

describe GeographicAreasGeographicItem do
  let(:geographic_areas_geographic_item) {FactoryGirl.build(:geographic_areas_geographic_item)}
  let(:valid_geographic_areas_geographic_item) {FactoryGirl.build(:valid_geographic_areas_geographic_item)}

  context 'validation' do
    before(:each) {
      geographic_areas_geographic_item.valid?
      valid_geographic_areas_geographic_item.valid?
    }

    context 'required fields' do
      specify 'geographic_item is required' do
        expect(geographic_areas_geographic_item.errors.include?(:geographic_item)).to be_true
      end

      specify 'geographic_area is required' do
        expect(geographic_areas_geographic_item.errors.include?(:geographic_area)).to be_true
      end
    end

    context 'required fields' do
      specify 'geographic_item is required' do
        expect(valid_geographic_areas_geographic_item).to respond_to(:geographic_area)
      end

      specify 'geographic_area is required' do
        expect(valid_geographic_areas_geographic_item).to respond_to(:geographic_item)
      end
    end
  end
end
