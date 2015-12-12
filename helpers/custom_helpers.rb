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

def calendar_title_date
  case page_type
  when 'day'
    Date.new(year, month, day).strftime('%b %e %Y')
  when 'month'
    Date.new(year, month, 1).strftime('%b %Y')
  when 'year'
    year
  end
end
