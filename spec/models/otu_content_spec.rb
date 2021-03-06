require 'rails_helper'

describe OtuContent, :type => :model do
  let(:otu_content) { OtuContent.new }

  context "reflections / foreign keys" do
    context "has many" do
    end  

    context "belongs to" do
      specify "otu" do
        expect(otu_content).to respond_to(:otu)
      end

    end 

  end

  context "concerns" do
  end

end

