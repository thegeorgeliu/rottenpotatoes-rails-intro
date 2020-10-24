class Movie < ActiveRecord::Base
  # Return all possible values of a movie rating
  def self.all_ratings
    ['G','PG','PG-13','R']
#     self.find(:all, :select => "rating")
  end
  
  # Retrieve movies that have the ratings in the list
  #   or all movies if the list is nil
  def self.with_ratings(ratings_list, sort_on)
    if ratings_list.nil?
      if sort_on.nil?
        Movie.all
      else
        Movie.order(sort_on)
      end
    else # if there are filters for ratings
        if sort_on.nil?
          Movie.where(rating: ratings_list)
        else
          Movie.where(rating: ratings_list).order(sort_on)
        end
    end
  end
end
