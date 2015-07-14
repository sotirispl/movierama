module MoviesHelper

# action to create ajax response hash
def create_ajax_response(params)
	movie = Movie.find(params[:movie_id])
	hash = {:show_like_link => show_review_action(movie, true), 
			:show_hate_link => show_review_action(movie, false), 
			:likes => movie.likes, 
			:hates => movie.hates, 
			:action_label => show_review_label(movie),
			:update_like => update_review(movie, status),
			:update_hate => update_review(movie, status)}
	return hash
end

# action that returns the Unlike/Unhate link
def show_review_label(movie)
	# if user reviewed already check if 'Unlike' or 'Unhate' link
	# else no link
	check = user_already_reviewed(movie)
	if check == 0
	  reviewFound = movie.reviews.where('user_id' => current_user.id).first
	  @show_review_label = '<a href="#" class="delete-review" data-movieid="'+movie.id.to_s+'" data-id="'+reviewFound.id.to_s+'">Unlike</a>'  
	elsif check == 1 
	  reviewFound = movie.reviews.where('user_id' => current_user.id).first
	  @show_review_label = '<a href="#" class="delete-review" data-movieid="'+movie.id.to_s+'" data-id="'+reviewFound.id.to_s+'">Unhate</a>'
	else
	  @show_review_label = ''
	end
	# make string html safe
	@show_review_label.html_safe
end

# action that checks if a user can like or hate a movie
def show_review_action(movie, status)
	check = user_already_reviewed(movie)
	if check == -1
	  @show_review_action = true  
	elsif (check == 0 && status == true) || (check == 1 && status == false) || check == 2
	  @show_review_action = false  
	else
	  @show_review_action = true
	end

end

# action called to check if a review for the movie is already done by the user
def update_review(movie, status)
	check = user_already_reviewed(movie)
	#if none returns 0
	if check == -1
	  @update_review = 0
	#else returns the review id  
	else
	  reviewFound = movie.reviews.where('user_id' => current_user.id).first
	  @update_review = reviewFound.id
	end
end

private

# action to check if a user already reviewed a movie
# return -1 : not even signed in
# 		  0 : liked
# 		  1 : hated
def user_already_reviewed(movie)
  	@user_already_reviewed = -1
  	if user_signed_in? 

	  reviewFound = movie.reviews.where('user_id' => current_user.id).first
	  if reviewFound && reviewFound.status == true
	    @user_already_reviewed = 0
	  elsif reviewFound && reviewFound.status == false
	    @user_already_reviewed = 1
	  elsif movie.user_id == current_user.id
	    @user_already_reviewed = 2
	  end
	end
  	return @user_already_reviewed
end

end
