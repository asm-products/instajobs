$('.signbtn a:first-child').click () ->
	$('.signupform').fadeIn()
	$('.loginform').fadeOut()
	$('.logbtn a:first-child').removeClass('selected');
	$('.signbtn a:first-child').addClass('selected');
	return 

$('.logbtn a:first-child').click () ->
	$('.signupform').fadeOut()
	$('.loginform').fadeIn()
	$('.signbtn a:first-child').removeClass('selected');
	$('.logbtn a:first-child').addClass('selected');
	return 