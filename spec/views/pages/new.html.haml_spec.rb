require 'rails_helper'

RSpec.describe 'pages/new', type: :view do
  let!(:root_page) do
    Page.create!(
      title: 'Root page',
      text: 'Text'
    )
  end
  let!(:page) do
    Page.create!(
      title: 'Page title',
      text: 'Page text',
      slug: 'first',
      parent: root_page
    )
  end

  before do
    assign(:page, page)
    params[:path] = page.path

    render
  end

  it 'renders the new page form' do
    assert_select 'form[action=?][method=?]', new_page_path(params[:path]), 'post' do
      assert_select 'select#page_parent_id[name=?]', 'page[parent_id]'
      assert_select 'input#page_slug[name=?]', 'page[slug]'
      assert_select 'input#page_title[name=?]', 'page[title]'
      assert_select 'textarea#page_text[name=?]', 'page[text]'
    end
  end

  it 'marks parent option selected' do
    assert_select 'select#page_parent_id > option[selected][value=?]', page.parent_id.to_s
  end
end
