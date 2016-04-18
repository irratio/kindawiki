require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'pages routing' do
    example do
      expect(get: '/').to route_to('pages#index')
    end

    example do
      expect(get: '/page/add').to route_to('pages#new', path: 'page')
    end

    example do
      expect(get: '/add').to route_to('pages#new')
    end

    example do
      expect(get: '/page').to route_to('pages#show', path: 'page')
    end

    example do
      expect(get: '/page/edit').to route_to('pages#edit', path: 'page')
    end

    example do
      expect(get: '/edit').to route_to('pages#edit')
    end

    example do
      expect(post: '/page/add').to route_to('pages#create', path: 'page')
    end

    example do
      expect(put: '/page/edit').to route_to('pages#update', path: 'page')
    end

    example do
      expect(patch: '/page/edit').to route_to('pages#update', path: 'page')
    end

    example do
      expect(delete: '/page').to route_to('pages#destroy', path: 'page')
    end
  end
end
