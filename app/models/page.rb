class Page < ActiveRecord::Base
  acts_as_tree order: 'slug'

  validates_presence_of :title
  validates_presence_of :text
  validates :slug,
    format: {
      with: /\A[a-zA-Z0-9_]*\z/,
      message: 'can contain only english letters, numbers and underscores'
    },
    exclusion: {
      in: %w(edit add),
      message: 'can’t be “%{value}”: it’s a reserved word'
    },
    uniqueness: {
      scope: :parent_id
    }
  validates_uniqueness_of :parent_id,
    if: proc { |page| page.parent_id == nil },
    message: 'can be omitted only on root page'


  def path
    if parent.present? && (parent_path = parent.path).present?
      "#{parent_path}/#{slug}"
    else
      slug.to_s
    end
  end

  def to_param
    path
  end
end
