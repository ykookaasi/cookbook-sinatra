class Recipe
   attr_accessor :name, :description, :rating, :preptime, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating]
    @done = attributes[:done] || false
    @prep_time = attributes[:prep_time]
  end

  def done?
    @done
  end

  def mark_as_done!
    @done = true
  end
end
