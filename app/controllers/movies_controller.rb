class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    order = params[:order_by]
    ratings = params[:ratings]
    
    # prepare for movies and the ratings checkbox options
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @checked_ratings = Hash[@all_ratings.collect { |item| [item, "1"] } ]

    # if ratings are specified, filter the movie with required ratings
    if ratings
      @movies = @movies.where(:rating => ratings.keys)
      @checked_ratings = ratings
    end
    
    # if order_by param exists, sort by this param
    if order == "title"
      @movies = @movies.order("title asc")
    elsif order == "release_date"
      @movies = @movies.order("release_date asc")
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

end
