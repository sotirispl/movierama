class MoviesController < ApplicationController
  before_action :set_movie, only: [:edit, :update]
  include MoviesHelper


  # GET /movies
  # GET /movies.json
  def index
    #check if there is a param to order movies
    if params.has_key?(:order) && params[:order] == 'date'
      @movies = Movie.order('created_at DESC').all
    elsif params.has_key?(:order) && params[:order] == 'likes'
      @movies = Movie.order('likes DESC').all
    elsif params.has_key?(:order) && params[:order] == 'hates'
      @movies = Movie.order('hates DESC').all
    else   
      @movies = Movie.all
    end

    #check if there is a param to filter by user
    if params.has_key?(:filter)
      @movies = @movies.where('user_id' => params[:filter])
    end
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    #create a movie for the current user
    @movie = current_user.movies.new(movie_params)
    respond_to do |format|
      if @movie.save
        format.html { redirect_to movies_url, notice: 'Movie was successfully created.' }
        format.json { render :index, status: :ok, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :index, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :description, :user_id, :hates, :likes, :image)
    end

    
end
