class Movie < ActiveRecord::Base
  # Return all possible values of a movie rating
  def self.all_ratings
    ['G','PG','PG-13','R']
#     self.find(:all, :select => "rating")
  end
  
  # Retrieve movies that have the ratings in the list
  #   or all movies if the list is nil
  def self.with_ratings(ratings_list)
    if ratings_list.nil?
      Movie.all
    else
      Movie.where(rating: ratings_list)
    end
  end
end
