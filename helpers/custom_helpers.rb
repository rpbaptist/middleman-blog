def provide_summary(article)
  parsed_article = Nokogiri::HTML(article.summary)
  parsed_article.search('section').inner_html
end

def articles_by_category
  category_articles = { "technical" => [], "cultural" => [] }
  blog.articles.each{ |article| category_articles[article.metadata[:page]["category"]] << article }
  category_articles
end
