require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "csv"

require_relative "models/cookbook"
require_relative "models/recipe"
require_relative "services/scraper"
require_relative 'scraper'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  csv_file = File.join(__dir__, 'recipes.csv')
  cookbook = Cookbook.new(csv_file)
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe = Recipe.new(params[:name], params[:description])
  cookbook.add(recipe)
  redirect to '/'
end

get '/recipes/:index' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  cookbook.remove_at(params[:index].to_i)
  redirect to '/'
end

get '/search' do
  @results = ScrapeAllrecipesService.find_recipes(params[:keyword])
  @keyword = params[:keyword]
  erb :search_index
end

get '/search/:index/save' do
  csv_file = File.join(__dir__, 'recipes.csv')
  cookbook = Cookbook.new(csv_file)
  new_recipe = Recipe.new(
    @results[params[:index].to_i][:name],
    @results[params[:index].to_i][:description],
    @results[params[:index].to_i][:prep_time],
    @results[params[:index].to_i][:rating]
  )
  cookbook.add(new_recipe)
  redirect to '/'
end

set :bind, '0.0.0.0'
