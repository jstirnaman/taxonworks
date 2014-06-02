shared_examples 'a_login_required_and_project_selected_controller' do

  let(:index_path) { url_for(example.metadata[:base_class]) }
  let(:page_index_name) { example.metadata[:page_index_name] }

  describe 'authorization' do
    describe "submitting request without sign_in redirects to root_path" do
      before { visit index_path  }
      specify { 
        expect(page).to have_button 'Sign in'
      }
    end

    describe "submitting a request with sign_in but no project redirects to dashboard" do
     before(:each) {
       sign_in_valid_user
       visit index_path 
     }
     specify { expect(page).to have_content 'Dashboard' }
    end

    describe "submitting a request with sign_in and project selected renders " do
      before(:each) {
        sign_in_valid_user
        select_a_project
        visit index_path 
      }
      specify { 
        expect(page).to have_content page_index_name 
      }
    end
  end
end

