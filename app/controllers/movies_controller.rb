class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      @ratings_to_show = @all_ratings
      if not params[:ratings].nil?
        @ratings_to_show = params[:ratings].keys
      elsif not session[:ratings_to_show].nil?
        @ratings_to_show = session[:ratings_to_show]
        params[:ratings_to_show] = @ratings_to_show
        movies_path({ratings_to_show: @ratings_to_show})
      end
      
      @movie_title_header_color = ''
      @release_date_header_color = ''
      @movie_title_header = ''
      @release_date_header = ''

      if not params[:movie_title_header].nil?
        @movie_title_header = params[:movie_title_header]
      elsif not params[:release_date_header].nil?
        @release_date_header = params[:release_date_header]
      elsif not session[:movie_title_header].nil?
        @movie_title_header = session[:movie_title_header]
        params[:movie_title_header] = @movie_title_header
        movies_path({movie_title_header: @movie_title_header})
      elsif not session[:release_date_header].nil?
        @release_date_header = session[:release_date_header]
        params[:release_date_header] = @release_date_header
        movies_path({release_date_header: @release_date_header})
      else
        session.clear
      end

      if @movie_title_header == "1"
        @movie_title_header_color = 'hilite bg-warning'
        @release_date_header_color = ''
        @movies = Movie.with_ratings(@ratings_to_show).order("title")
        session.clear
        session[:movie_title_header] = "1"
        session[:ratings_to_show] = @ratings_to_show
      elsif @release_date_header == "1"
        @release_date_header_color = 'hilite bg-warning'
        @movie_title_header_color = ''
        @movies = Movie.with_ratings(@ratings_to_show).order("release_date")
        session.clear
        session[:release_date_header] = "1"
        session[:ratings_to_show] = @ratings_to_show
      else
        @movies = Movie.with_ratings(@ratings_to_show)
        session.clear
        session[:ratings_to_show] = @ratings_to_show
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