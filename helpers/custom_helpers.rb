
def provide_summary(article)
  parsed_article = Nokogiri::HTML(article.summary)
  parsed_article.search('section').inner_html
end
