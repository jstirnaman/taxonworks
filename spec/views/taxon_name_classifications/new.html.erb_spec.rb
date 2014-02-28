require 'spec_helper'

describe "taxon_name_classifications/new" do
  before(:each) do
    assign(:taxon_name_classification, stub_model(TaxonNameClassification,
      :taxon_name_id => 1,
      :type => "",
      :created_by_id => 1,
      :updated_by_id => 1,
      :project_id => 1
    ).as_new_record)
  end

  it "renders new taxon_name_classification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", taxon_name_classifications_path, "post" do
      assert_select "input#taxon_name_classification_taxon_name_id[name=?]", "taxon_name_classification[taxon_name_id]"
      assert_select "input#taxon_name_classification_type[name=?]", "taxon_name_classification[type]"
      assert_select "input#taxon_name_classification_created_by_id[name=?]", "taxon_name_classification[created_by_id]"
      assert_select "input#taxon_name_classification_updated_by_id[name=?]", "taxon_name_classification[updated_by_id]"
      assert_select "input#taxon_name_classification_project_id[name=?]", "taxon_name_classification[project_id]"
    end
  end
end