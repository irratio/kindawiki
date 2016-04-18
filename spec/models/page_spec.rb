require 'rails_helper'

RSpec.describe Page, type: :model do
  it { is_expected.to respond_to(:parent_id) }
  it { is_expected.to respond_to(:parent) }
  it { is_expected.to respond_to(:children) }
  it { is_expected.to respond_to(:root?) }
  it { is_expected.to respond_to(:leaf?) }
  it { is_expected.to respond_to(:path) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to allow_values('page_slug', '000', '0_0').for(:slug) }
    it { is_expected.to_not allow_values('(-_-)', ' slug', '-').for(:slug) }
    it { is_expected.to validate_exclusion_of(:slug).in_array(%w(edit add)).with_message(/reserved/) }
    it { is_expected.to validate_uniqueness_of(:slug).scoped_to(:parent_id) }
  end

  describe '.find_root' do
    context 'when there is no root page' do
      it 'returns nil' do
        expect(Page.find_root).to be_nil
      end
    end

    context 'when root page exists' do
      let!(:root_page) { Page.create!(title: 'Root page', text: 'Text') }
      subject { Page.find_root }

      it 'returned object should be Page' do
        is_expected.to be_a Page
      end

      it 'returned object should be root page' do
        is_expected.to be_root
      end

      it 'returned page title should match initial value' do
        expect(subject.title).to eq('Root page')
      end
    end
  end

  describe '#path' do
    context 'without parent' do
      it 'returns empty string' do
        expect(subject.path).to eq('')
      end
    end

    context 'when single parent present' do
      let(:root_page) { Page.new }
      subject { Page.new(parent: root_page, slug: 'page') }

      it 'returns slug' do
        expect(subject.path).to eq('page')
      end
    end

    context 'when there are multiple ancestors' do
      let(:root_page) { Page.new }
      let(:parent_page) { Page.new(parent: root_page, slug: 'parent') }
      subject { Page.new(parent: parent_page, slug: 'page') }

      it 'returns slash-divided family slugs' do
        expect(subject.path).to eq('parent/page')
      end
    end
  end

  describe '#root?' do
    context 'without parent' do
      it 'returns true' do
        expect(subject.root?).to be true
      end
    end

    context 'when parent present' do
      let(:root_page) { Page.new(title: 'Root page', text: 'Text') }
      subject { Page.new(parent: root_page) }

      it 'returns false' do
        expect(subject.root?).to be false
      end
    end
  end
end
