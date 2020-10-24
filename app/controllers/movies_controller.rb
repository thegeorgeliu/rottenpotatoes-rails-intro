class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # Filter list of movies with certain ratings
    if params[:ratings].nil?
      # Check if a filter is saved in the session
      if !session[:ratings].nil?
        @ratings_to_show = session[:ratings]
        redirect_to movies_path(:ratings => @ratings_to_show.zip(['1', '1', '1']).to_h)
      else
        @ratings_to_show = @all_ratings
      end
    else # if ratings is not nil
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show # save to session
    end
    
    # Highlight the header of a column if it is sorted
    if params[:order] == 'title'
      @order = 'title'
      @title_class = 'hilite bg-warning'
    elsif params[:order] == 'release_date'
      @order = 'release_date'
      @date_class = 'hilite bg-warning'
    end
    
    # Show selected movies
    if params[:order].nil?
      if !session[:order].nil?
        @movies = Movie.with_ratings(@ratings_to_show, session[:order])
      else
        @movies = Movie.with_ratings(@ratings_to_show, nil)
      end
    else
      @movies = Movie.with_ratings(@ratings_to_show, params[:order])
      session[:order] = params[:order]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
