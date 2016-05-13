require 'middleman-gh-pages'

# Blog settings
activate :blog do |blog|
  blog.sources = "articles/{category}/{year}-{month}-{day}-{title}.html"
  blog.permalink = "{year}/{month}/{day}/{title}.html"
  blog.taglink = "tags/{tag}.html"
  blog.layout = "article_layout"
  blog.summary_separator = /(READMORE)/
  blog.year_link = "{year}.html"
  blog.month_link = "{year}/{month}.html"
  blog.custom_collections = {
    category: {
      link: 'categories/{category}.html',
      template: 'category.html'
    }
  }
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

# Helpers
# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes
activate :syntax

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, tables: true, autolink: true, gh_blockcode: true

# Reload the browser automatically whenever files change
activate :livereload

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  activate :relative_assets
end
