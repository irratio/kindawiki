# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

root_page = Page.create(
  slug: '',
  title: 'Kinda wiki',
  text: 'Welcome to your new kindawiki!'
)

%w(one two three).each do |n|
  Page.create(
    slug: n,
    title: "Page #{n}",
    text: "Text for the page #{n}",
    parent: root_page
  )
end

page = root_page.children.first

%w(first second third fourth).each do |n|
  Page.create(
    slug: n,
    title: "#{n} subpage",
    text: "Text for #{n} subpage",
    parent: page
  )
end

Page.create(
  title: 'Another subpage',
  slug: 'subpage',
  text: 'Text text text',
  parent: page.children.first
)
