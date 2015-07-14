// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-modal
//= require bootstrap-modalmanager
//= require_tree .


$(document).ready(function(){

	//onclick handler for the user icon - toggles the menu
	$('body').on('click', 'a.user-menu', function(ev){
		ev.preventDefault();
		$("div.user-menu-container").slideToggle("fast");
	});


	//onclick handler for the review (like/hate) of a movie
	$('body').on('click', '.reviewMovie', function(ev){
		ev.preventDefault();
		var movieId = $(this).attr('data-id');
		var reviewMethod = $(this).attr('data-method');
		var reviewStatus = $(this).attr('data-status');
		reviewMovie(movieId, reviewStatus, reviewMethod);
		return false;
	});

	//onclick handler for Unlike/Unhate links
	$('body').on('click', '.delete-review', function(ev){
		ev.preventDefault();
		var reviewId = $(this).attr('data-id');
		var movieId = $(this).attr('data-movieid');
		deleteReview(reviewId, movieId);
		return false;
	});
});

//creates the Unlike/Unhate link element 
function createReviewLink(movieId, updateMethod, status) {
	var id = 'linkLike'+movieId;
	if(status == false) {
		id = 'linkHate'+movieId;
	}
	return $('<a/>', {
        'id':id,
        'class':'reviewMovie',
        'data-id':movieId,
        'data-status':status,
        'data-method':updateMethod,
        'href':'#'			       
    })
}

//handles the ajax response - changes the review names and links
function handleAjaxResponse(movieId, response) {
	$("#likeReview"+movieId).text($(response).attr('likes'));
	$("#hateReview"+movieId).text($(response).attr('hates'));
	$("#reviewMovie"+movieId).html($(response).attr('action_label'));

	if($(response).attr('show_like_link') == false) {
		$('a#linkLike'+movieId).contents().unwrap();
	} else {
		if ( $( "#linkLike"+movieId ).length == 0 ) {
			$("#likesContainer"+movieId).wrap(
				createReviewLink(movieId, $(response).attr('update_like'), true)
			);
		} else {
			$('a#linkLike'+movieId).attr('data-method', $(response).attr('update_like'));	
		}	
	}
	if($(response).attr('show_hate_link') == false) {
		$('a#linkHate'+movieId).contents().unwrap();
	} else {
		if ( $( "#linkHate"+movieId ).length == 0 ) {
			$("#hatesContainer"+movieId).wrap(
				createReviewLink(movieId, $(response).attr('update_hate'), false)
			);
		} else {
			$('a#linkHate'+movieId).attr('data-method', $(response).attr('update_hate'));	
		}	
	}	
}

//ajax call to delete a review (Unlike/Unhate)
function deleteReview(id, movieId) {
	$.ajax({
	  method: "DELETE",
	  url: '/reviews/'+id
	}).done(function(response) {
		handleAjaxResponse(movieId, response);
	}).fail(function(){
		alert('You are not allowed to this action!');
	});	
}

//ajax call to create (post) or update (put) a review
//if method is 0 then it means there is no review already => post
//else if method is > 0 then there is a review to update => put
function reviewMovie(id, status, method) {
	var methodAttr = "POST";
	var url = "/reviews";
	if(method != 0){
		methodAttr = "PUT";
		url = "/reviews/:"+method
	}
	$.ajax({
	  method: methodAttr,
	  url: url,
	  data: { review : {status: status, movie_id: id} }
	}).done(function(response) {
		handleAjaxResponse(id, response);
	}).fail(function(){
		alert('You are not allowed to this action!');
	});
	return false;
}
