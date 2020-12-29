require 'open-uri'
require 'nokogiri'

# require_relative 'models/recipe'

class ScrapeAllrecipesService

  def search(keyword)
    url = "https://www.allrecipes.com/search/?wt=#{keyword}"
    # file = 'chocolate.html'
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    # doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')
    results = []
    doc.search(".fixed-recipe-card__info").first(10).each do |elements|
      name = elements.search(".fixed-recipe-card__h3").text.strip
      description = elements.search(".fixed-recipe-card__description").text.strip
      rating = elements.search(".fixed-recipe-card__ratings span").attribute("data-ratingstars").value.to_f.round
      recipe_link = elements.search("a").first["href"]
      prep_time = get_prep_time(recipe_link)
      results << Recipe.new(name: name, description: description, rating: rating, prep_time: prep_time)
    end
    results
  end

  def get_prep_time(recipe_link)
    doc = Nokogiri::HTML(open(recipe_link), nil, 'utf-8')
    doc.search(".recipe-meta-item-body").first.text.strip
  end
end
