### 
# Compass
###

# Susy grids in Compass
# First: gem install compass-susy-plugin
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Haml
###

# CodeRay syntax highlighting in Haml
# First: gem install haml-coderay
# require 'haml-coderay'

# CoffeeScript filters in Haml
# First: gem install coffee-filter
# require 'coffee-filter'

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

###
# Page command
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Blog articles
###

require 'JSON'
require 'redcarpet'
require 'pygments'
require 'active_support/core_ext/integer/inflections'

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight code, lexer: language, options: { encoding: 'utf-8' }
  end
end

def extract_info dirname
  /^(?<date>\d{4}-\d{2}-\d{2})-(?<slug>.*)$/.match dirname
end

articles = []
md = Redcarpet::Markdown.new(HTMLwithPygments.new(with_toc_data: true), fenced_code_blocks: true, strikethrough: true, superscript: true)

Dir["source/read/*/main.md"].each do |file|
  match = /^(?<date>\d{4}-\d{2}-\d{2})-(?<slug>.*)$/.match(File.basename File.dirname file)
  json = File.join(Dir.pwd, File.dirname(file), "attributes.json")

  File.open json do |f|
    attr = JSON.parse f.read, symbolize_names: true
    slug = match[:slug]
    time = Time.parse match[:date]

    articles << {slug: slug, time: time, title: attr[:title], tagline: attr[:tagline]}

    page "/read/#{slug}.html", proxy: "/read.html.haml", ignore: true do
      @file =    file
      @slug =    slug
      @time =    time
      @title =   attr[:title]
      @tagline = attr[:tagline]
      @content = md.render File.read(file)
    end
  end
end

page "/articles.html", proxy: "/articles.html.haml", ignore: true do
  @articles = articles.each {|a| a[:url] = "/read/#{a[:slug]}" }.sort {|a, b| b[:time] <=> a[:time] }
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, "css"

set :js_dir,  "js"

# Change the images directory
# set :images_dir, "alternative_image_directory"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  
  # Minify Javascript on build
  activate :minify_javascript
  
  # Enable cache buster
  activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end

