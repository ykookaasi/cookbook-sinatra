require 'open-uri'
require 'nokogiri'

require_relative 'recipe'

class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def search
    url = "https://www.allrecipes.com/search/?wt=#{@keyword}"
    # file = 'chocolate.html'
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    # doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')
    results = []
    doc.search(".fixed-recipe-card__info").first(5).each do |elements|
      name = elements.search(".fixed-recipe-card__h3").text.strip
      description = elements.search(".fixed-recipe-card__description").text.strip
      rating = elements.search(".fixed-recipe-card__ratings span").attribute("data-ratingstars").value.to_f.round
      recipe_link = elements.search("a").first["href"]
      preptime = get_preptime(recipe_link)
      results << Recipe.new(name: name, description: description, rating: rating, preptime: preptime)
    end
    results
  end

  def get_preptime(recipe_link)
    doc = Nokogiri::HTML(open(recipe_link), nil, 'utf-8')
    doc.search(".recipe-meta-item-body").first.text.strip
  end
end
