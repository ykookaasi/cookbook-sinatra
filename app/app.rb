require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "csv"

require_relative "models/cookbook"
require_relative "models/recipe"
require_relative "services/scrape_allrecipes"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

COOKBOOK = Cookbook.new(File.join(__dir__, 'recipes.csv'))
SCRAPER = ScrapeAllrecipesService.new

get '/' do
  @recipes = COOKBOOK.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes/create' do
  recipe = Recipe.new(params)
  COOKBOOK.add_recipe(recipe)
  redirect to '/'
end

get '/recipes/:id/delete_at' do
  COOKBOOK.remove_at(params[:index].to_i)
  redirect to '/'
end

get '/search' do
  erb :search
end

get '/search/recipes' do
  @results = SCRAPER.search(params[:keyword])
  @keyword = params[:keyword]
  erb :search_index
end

# post '/search/recipes/:index/save' do
#   recipe = Recipe.new(
#     params[:name],
#     params[:description],
#     params[:rating],
#     params[:prep_time],
#     params[:tested]
#   )
#   COOKBOOK.add(new_recipe)
#   redirect to '/'
# end

set :bind, '0.0.0.0'
