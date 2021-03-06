require 'rails_helper'

describe RepositoriesHelper, :type => :helper do
  context 'a repository needs some helpers' do
    let(:repository) {FactoryGirl.create(:valid_repository)}

    specify '::repository_tag' do
      expect(RepositoriesHelper.repository_tag(repository)).to eq(repository.name)
    end

    specify '.repository_tag' do
      expect(helper.repository_tag(repository)).to eq(repository.name)
    end

    specify '.repository_link' do
      expect(helper.repository_link(repository)).to have_link(repository.name)
    end

    specify ".repositoies_search_form" do
      expect(helper.repositories_search_form).to have_button('Show')
      expect(helper.repositories_search_form).to have_field('repository_id_for_quick_search_form')
    end

  end
end
