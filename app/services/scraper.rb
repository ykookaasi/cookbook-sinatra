require 'open-uri'
require 'nokogiri'

require_relative 'recipe'

class ScrapeAllrecipesService
  def self.search(keyword)
    base_url = 'https://www.allrecipes.com/search/?wt='
    url = "#{base_url}#{keyword}"
    # file = 'chocolate.html'
    html_doc = get_html(url)
    target = '.recipe-meta-item-body'

    find_recipes(html_doc, target)
  end

  def self.get_html(url)
    html_file = File.open(url)
    Nokogiri::HTML(html_file, nil, 'utf-8')
  end

  def self.find_recipes(html_doc, target)
    results = []

    html_doc.search(target).first(5).each do |element|
      name = find_name(element)
      description = find_description(element)
      rating = find_rating(element)
      recipe_link = find_recipe_link(element)
      preptime = get_preptime(recipe_link)
      results << Recipe.new(name: name, description: description, rating: rating, preptime: preptime)
    end
    results
  end

  def find_name(element)
    element.search('.fixed-recipe-card__h3').text.strip
  end

  def find_description(element)
    element.search('.fixed-recipe-card__description').text.strip
  end

  def find_rating(element)
    element.search('.fixed-recipe-card__ratings span').attribute("data-ratingstars").value.to_f.round
  end

  def find_recipe_link(element)
    element.search('a').first['href']
  end

  def get_preptime(recipe_link)
    doc = Nokogiri::HTML(File.open(recipe_link), nil, 'utf-8')
    doc.search('.recipe-meta-item-body').first.text.strip
  end
end
