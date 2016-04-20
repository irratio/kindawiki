require 'rails_helper'

RSpec.describe 'pages/show', type: :view do
  let!(:root_page) do
    Page.create!(
      title: 'Root page',
      text: 'Text'
    )
  end
  let!(:first_lvl_page) do
    Page.create!(
      title: 'First level page',
      text: 'Text',
      slug: 'first',
      parent: root_page
    )
  end
  let!(:second_lvl_page) do
    Page.create!(
      title: 'Second level page',
      text: 'Text',
      slug: 'second',
      parent: first_lvl_page
    )
  end

  before do
    assign(:page, first_lvl_page)
    render
  end

  it 'renders page title' do
    expect(rendered).to include('First level page')
  end

  it 'renders page text' do
    expect(rendered).to include('Text')
  end

  it 'renders link to child page' do
    expect(rendered).to include(second_lvl_page.path)
  end

  it 'renders "edit" link' do
    expect(rendered).to include(edit_page_path(first_lvl_page))
  end

  it 'renders "add subpage" link' do
    expect(rendered).to include(new_page_path(first_lvl_page))
  end
end
