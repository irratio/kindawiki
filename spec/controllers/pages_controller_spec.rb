require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:root_page_attributes) { {
    title: 'Root page',
    text: 'Root page text',
    slug: ''
  } }

  let(:valid_attributes) { {
    title: 'Page title',
    text: 'Page text',
    slug: 'page',
    parent_id: root_page.id
  } }

  let(:invalid_attributes) { {
    title: '',
    text: '',
    slug: 'invalid slug',
    parent_id: root_page.id
  } }

  describe 'GET #index' do
    context 'when root page is present' do
      let!(:root_page) { Page.create! root_page_attributes }

      before do
        get :index
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :show }

      it 'assigns root page as @page' do
        expect(assigns(:page)).to be_a(Page)
        expect(assigns(:page)).to eq(root_page)
      end
    end

    context 'when root page is not present' do
      before do
        get :index
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a new root page as @page' do
        expect(assigns(:page)).to be_a_new(Page)
        expect(assigns(:page)).to be_root
      end
    end
  end

  describe 'GET #show' do
    context 'when path is valid' do
      let!(:root_page) { Page.create! root_page_attributes }
      let(:page) { Page.create! valid_attributes }

      before do
        get :show, {path: page.to_param}
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :show }

      it 'assigns the requested page as @page' do
        expect(assigns(:page)).to eq(page)
      end
    end

    context 'when path is invalid' do
      it 'throws an error' do
        expect {
          get :show, {path: 'not/real/page'}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    context 'when path is empty and there is no root page' do
      before do
        get :new, {path: ''}
      end

      it { is_expected.to redirect_to '/' }
    end

    context 'when path is empty and root page exists' do
      let!(:root_page) { Page.create! root_page_attributes }

      before do
        get :new, {path: ''}
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a new page as @page' do
        expect(assigns(:page)).to be_a_new(Page)
      end

      it 'sets new page parent' do
        expect(assigns(:page).parent).to eq(root_page)
      end
    end

    context 'when path is invalid and there is no root page' do
      before do
        get :new, {path: 'not/real/page'}
      end

      it { is_expected.to redirect_to '/' }
    end

    context 'when path is invalid and root page exists' do
      let!(:root_page) { Page.create! root_page_attributes }

      before do
        get :new, {path: 'not/real/page'}
      end

      it { is_expected.to redirect_to '/add' }
    end

    context 'when path is valid' do
      let!(:root_page) { Page.create! root_page_attributes }
      let(:page) { Page.create! valid_attributes }

      before do
        get :new, {path: page.path}
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a new page as @page' do
        expect(assigns(:page)).to be_a_new(Page)
      end

      it 'sets new page parent' do
        expect(assigns(:page).parent).to eq(page)
      end
    end
  end

  describe 'GET #edit' do
    context 'when path is empty and there is no root page' do
      it 'throws an error' do
        expect {
          get :edit, {path: ''}
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when path is empty and root page exists' do
      let!(:root_page) { Page.create! root_page_attributes }

      before do
        get :edit, {path: ''}
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :edit }

      it 'assigns the root page as @page' do
        expect(assigns(:page)).to eq(root_page)
      end
    end

    context 'when path is invalid' do
      it 'throws an error' do
        expect {
          get :edit, {path: 'not/real/page'}
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when path is valid' do
      let!(:root_page) { Page.create! root_page_attributes }
      let(:page) { Page.create! valid_attributes }

      before do
        get :edit, {path: page.path}
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :edit }

      it 'assigns the requested page as @page' do
        expect(assigns(:page)).to eq(page)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let!(:root_page) { Page.create! root_page_attributes }

      it 'creates a new Page' do
        expect {
          post :create, {page: valid_attributes}
        }.to change(Page, :count).by(1)
      end

      it 'assigns a newly created page as @page' do
        post :create, {page: valid_attributes}
        expect(assigns(:page)).to be_a(Page)
        expect(assigns(:page)).to be_persisted
      end

      it 'redirects to the created page' do
        post :create, {page: valid_attributes}
        expect(response).to redirect_to(Page.last)
      end

      it 'sets notice message' do
        post :create, {page: valid_attributes}
        expect(flash[:notice]).to match(/successfully created/)
      end
    end

    context 'with invalid params' do
      let!(:root_page) { Page.create! root_page_attributes }

      before do
        post :create, {page: invalid_attributes}
      end

      it { is_expected.to respond_with :ok }

      it 'assigns a newly created but unsaved page as @page' do
        expect(assigns(:page)).to be_a_new(Page)
      end

      it 're-renders the template "new"' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let!(:root_page) { Page.create! root_page_attributes }

    let(:new_attributes) { {
      title: 'New page title',
      text: 'Updated page text',
      slug: 'new_page',
      parent: root_page
    } }

    context 'when page doesn’t exist' do
      before do
        put :update, {path: 'not/real/page', page: new_attributes}
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'shows a warning' do
        expect(flash[:notice]).to match(/doesn.t exist/)
      end

      it 'assigns a new page as @page' do
        expect(assigns(:page)).to be_a_new(Page)
      end
    end

    context 'with valid params' do
      let(:page) { Page.create! valid_attributes }

      before do
        put :update, {path: page.to_param, page: new_attributes}
      end

      it 'updates the requested page' do
        page.reload
        expect(page.title).to eq('New page title')
      end

      it 'assigns the requested page as @page' do
        expect(assigns(:page)).to eq(page)
      end

      it 'redirects to the page' do
        page.reload
        expect(response).to redirect_to(page)
      end

      it 'sets notice message' do
        expect(flash[:notice]).to match(/successfully updated/)
      end
    end

    context 'with invalid params' do
      let(:page) { Page.create! valid_attributes }

      before do
        put :update, {path: page.to_param, page: invalid_attributes}
      end

      it 'assigns the page as @page' do
        expect(assigns(:page)).to eq(page)
        expect(assigns(:page).slug).to eq('invalid slug')
      end

      it 're-renders template edit' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when path is empty and root page doesn’t exist' do
      it 'throws an error' do
        expect {
          delete :destroy, {path: 'not/real/page'}
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when path is empty and root page exists' do
      let!(:root_page) { Page.create! root_page_attributes }

      it 'destroys the root page' do
        expect {
          delete :destroy, {path: ''}
        }.to change(Page, :count).by(-1)
      end

      it 'redirects to root' do
        delete :destroy, {path: ''}
        expect(response).to redirect_to '/'
      end
    end

    context 'when path is invalid' do
      it 'doesn’t destroy anything and throws an error' do
        expect {
          delete :destroy, {path: 'not/real/page'}
        }.to raise_error(ActionController::RoutingError).and avoid_changing { Page.count }
      end
    end

    context 'when path is valid' do
      let!(:root_page) { Page.create! root_page_attributes }
      let!(:page) { Page.create! valid_attributes }

      it 'destroys the requested page' do
        expect {
          delete :destroy, {path: page.to_param}
        }.to change(Page, :count).by(-1)
      end

      it 'redirects to the parent page' do
        delete :destroy, {path: page.to_param}
        expect(response).to redirect_to(page_url(page.parent))
      end

      it 'sets notice message' do
        delete :destroy, {path: page.to_param}
        expect(flash[:notice]).to match(/successfully destroyed/)
      end
    end

    context 'when path is valid, but page has children' do
      let!(:root_page) { Page.create! root_page_attributes }
      let!(:page) { Page.create! valid_attributes }
      let!(:child_page) { Page.create!(title: 'Child page', text: 'text', slug: 'child', parent: page) }

      it 'doesn’t destroy anything' do
        expect {
          delete :destroy, {path: page.to_param}
        }.to_not change(Page, :count)
      end

      it 'redirects to the edit page' do
        delete :destroy, {path: page.to_param}
        expect(response).to redirect_to(edit_page_url(page))
      end

      it 'sets notice message' do
        delete :destroy, {path: page.to_param}
        expect(flash[:notice]).to match(/cannot be destroyed/)
      end
    end
  end
end
