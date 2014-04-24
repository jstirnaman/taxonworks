require 'spec_helper'

describe BiocurationGroup do

  let(:biocuration_group) {FactoryGirl.build(:biocuration_group)}

  context 'has many' do
    before(:each) {
      @biocuration_group = FactoryGirl.create(:valid_biocuration_group, name: 'Stages.', definition: 'Life stages.')
      @bc1 = BiocurationClass.create(name: 'Adult', definition: 'A mature indivdiual.') 
      @bc2 = BiocurationClass.create(name: 'Larva', definition: 'Not a mature indivdiual.') 
    }

    specify 'tags (through Keywords)' do
      expect(biocuration_group.tags << Tag.new(keyword: FactoryGirl.create(:valid_keyword))).to be_true
    end

    specify 'biocuration_classes' do
      expect(biocuration_group).to respond_to(:biocuration_classes)
      t1 =Tag.create(keyword: @biocuration_group, tag_object: @bc1)
      t2 = Tag.create(keyword: @biocuration_group, tag_object: @bc2)
 
      # Something to not match 
      t3 = Tag.create(keyword: FactoryGirl.create(:valid_keyword), tag_object: @bc1) 

      expect(@biocuration_group.biocuration_classes).to have(2).things
      expect(@biocuration_group.biocuration_classes.to_a.map(&:class)).to eq([BiocurationClass, BiocurationClass])
    end
  end
end
