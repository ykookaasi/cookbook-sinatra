class Recipe
  attr_reader :name, :description, :rating, :prep_time, :tested

  def initialize(params)
    @name = params[:name]
    @description = params[:description]
    @rating = params[:rating]
    @prep_time = params[:prep_time]

    @tested = params[:done] == "true" ? true : false
  end

  def mark_as_tested!
    @tested = true
  end
end
