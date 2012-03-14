class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order = ''
    @ratings = {}
    @all_ratings = Movie.all_ratings
    @header_classes = {:title => "", :release_date => ""}

    if params.has_key?(:ratings)
      @ratings = params[:ratings]
    end

    if params.has_key?(:order)
      @order = params[:order]
      @header_classes[@order.to_sym] = "hilite"
    end

    @movies = Movie.find(:all, :order => @order, :conditions => ["rating IN (?)", @ratings.keys])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
