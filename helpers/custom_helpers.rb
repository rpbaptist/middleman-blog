def provide_summary(article)
  parsed_article = Nokogiri::HTML(article.summary)
  parsed_article.search('section').inner_html
end

def articles_by_category
  category_articles = { 'technical' => [], 'cultural' => [] }
  blog.articles.each do |article|
    category_articles[article.metadata[:page]['category']] << article
  end
  category_articles
end

def contact_button(contact_url, name)
  link_to '', contact_url, class: "fa fa-#{name}-square fa-3x footer--contact--item__link"
end

def header_image(image_name)
  return unless image_name
  image_tag "/images/blog/#{image_name}", class: 'article--header--image'
end
