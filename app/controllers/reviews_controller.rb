class ReviewsController < ApplicationController
	include MoviesHelper
	def index
		@reviews = Review.all
	end

	def show
	end

	def new
		@review = Review.new
	end

	# update a review
	def update
		oldReview = Review.where({movie_id: review_params[:movie_id], user_id: current_user.id}).first 
		@review = Review.find(oldReview.id).update(review_params)
		
		# change the movie's counters
		if (oldReview.status == true && review_params[:status] == "false") 
			Movie.decrement_counter :likes, review_params[:movie_id]
			Movie.increment_counter :hates, review_params[:movie_id]
		elsif (oldReview.status == false && review_params[:status] == "true")
			Movie.decrement_counter :hates, review_params[:movie_id]
			Movie.increment_counter :likes, review_params[:movie_id]	 
		end
		# response as json
		render json: create_ajax_response(review_params).as_json, status: :ok
	end

	# delete a review
	def destroy
		@review = Review.find(params[:id])
		params[:movie_id] = @review.movie_id 
		# change the movie's counters
		if @review.destroy
			if @review.status == true
				Movie.decrement_counter :likes, @review.movie_id
			elsif @review.status == false
				Movie.decrement_counter :hates, @review.movie_id	 
			end
			# response as json
			render json: create_ajax_response(params).as_json, status: :ok
		else
			render json: {review: @review.as_json, status: :no_content}
		end
	end

	# create a review
	def create
		# only signed in users cant like/hate a movie
		if user_signed_in?
			# only one review per movie per user
			checkReview = current_user.reviews.where('movie_id' => review_params[:movie_id]).first;
			if checkReview
				render :status => 400
			else
				# if created then update the movie's counters
				@review = current_user.reviews.new(review_params)
				if @review.save
					if @review.status == true
						Movie.increment_counter :likes, review_params[:movie_id]
					elsif @review.status == false
						Movie.increment_counter :hates, review_params[:movie_id]	 
					end
					# response as json
					render json: create_ajax_response(review_params).as_json, status: :ok
				else
					render json: {review: @review.as_json, status: :no_content}
				end 
			end  
		else
			render json: {review: ''.as_json, status: :no_content}	
		end
	end

	def review_params
      params.require(:review).permit(:status, :movie_id, :user_id)
    end

end