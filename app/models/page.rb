class Page < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  acts_as_tree order: 'slug'

  before_validation :generate_slug
  before_destroy :check_children, prepend: true

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
    if: :root?,
    message: 'can be omitted only on root page'
  validates_presence_of :parent,
    unless: :root?


  def self.find_root
    find_by(parent_id: nil)
  end

  def self.find_by_path(path)
    slugs = path.to_s.split('/').unshift('')

    sql = 'SELECT pl.* FROM pages pl '

    slugs[0..-2].each_with_index do |slug, i|
      sql << "JOIN pages p#{i} ON "
      if i == 0
        sql << "p#{i}.parent_id IS NULL "
      else
        sql << "p#{i}.slug = '#{slug}' AND p#{i}.parent_id = p#{i - 1}.id "
      end
    end

    if slugs.length < 2
      sql << 'WHERE pl.parent_id IS NULL;'
    else
      sql << "WHERE pl.slug = '#{slugs.last}' AND pl.parent_id = p#{slugs.length - 2}.id;"
    end

    self.find_by_sql(sql).first
  end


  def root?
    !(parent || parent_id)
  end

  def path
    if parent.present? && (parent_path = parent.path).present?
      "#{parent_path}/#{slug}"
    else
      slug.to_s
    end
  end

  def text_html
    KindamarkupHtml.to_html(text)
  end

  def title_with_path
    if path.present?
      "#{title} (#{path})"
    else
      title
    end
  end

  def to_param
    path
  end

  def check_children
    unless leaf?
      errors[:base] << 'Page cannot be destroyed because it has children'
      false
    end
  end

  def generate_slug
    if slug.blank? && !root? && title.present?
      I18n.with_locale(:ru) do
        self.slug = title.to_s.parameterize('_')
      end

      if (taken_slugs = Page.where('parent_id = ? AND slug LIKE ?', parent_id, "#{slug}%").pluck(:slug)).present?
        i = 1
        possible_slug = slug

        while taken_slugs.include? possible_slug do
          i += 1
          possible_slug = "#{slug}_#{i}"
        end

        self.slug = possible_slug
      end
    end
  end
end
