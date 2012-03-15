class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order = session.has_key?(:order) ? session[:order] : ""
    @ratings = session.has_key?(:ratings) ? session[:ratings] : ""

    if params.has_key?(:ratings)
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    end

    if params.has_key?(:order)
      @order = params[:order]
      session[:order] = @order
    end

    if params[:ratings] != @ratings or params[:order] != @order
      redirect_to movies_path({:order => @order, :ratings => @ratings})
    end

    @header_classes = {:title => "", :release_date => ""}
    @header_classes[@order.to_sym] = "hilite"
    @all_ratings = Movie.all_ratings

    conditions = @ratings == "" ? [] : ["rating IN (?)", @ratings.keys]
    @movies = Movie.find(:all, :order => @order, :conditions => conditions)
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
