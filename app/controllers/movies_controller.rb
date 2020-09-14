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
    # prepare for movies and the ratings checkbox options
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @checked_ratings = Hash[@all_ratings.collect { |item| [item, "1"] } ]

    # set to keeping the flash after redirecting 
    # flash.keep
    # I tested the flash messages can be displayed correctly after redirecting, so I'm not gonna use flash.keep here.

    # if ratings are specified, filter the movie with required ratings
    if params[:ratings]
      @movies = @movies.where(:rating => params[:ratings].keys)
      @checked_ratings = params[:ratings]
      
      # set session for checkbox
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      # redirect for keeping restful api url and use the params in session
      redirect_to movies_path(:ratings => session[:ratings], :order_by => params[:order_by])
      return
    end
    
    # if order_by param exists, sort by this param
    if params[:order_by] and ['title', 'release_date'].include? params[:order_by]
      @movies = @movies.order("#{params[:order_by]} asc")
      
      # set session for order_by
      session[:order_by] = params[:order_by]
    elsif session[:order_by]
      # redirect for keeping restful api url and use the params in session
      redirect_to movies_path(:ratings => params[:ratings], :order_by => session[:order_by])
      return
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
