require 'spec_helper'

describe "AlternateValues", base_class: AlternateValue do

it_behaves_like 'a_login_required_and_project_selected_controller'

describe 'GET /alternate_values' do
  before { 
    sign_in_valid_user_and_select_project
    visit alternate_values_path }
  specify 'an index name is present' do
    expect(page).to have_content('Alternate Values')
  end
end
end
