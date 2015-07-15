setsignbtn = () ->
	$("#signupbtn").html("Create account");

setloginbtn = () ->
	$("#loginbtn").html("Sign In");

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

$('#signupbtn').click (event) ->
	event.preventDefault();
	$("#signupbtn").html("Creating account.....")
	values = $('.signupform form:first-child input');
	name = values[0].value
	email = values[1].value
	password = values[2].value
	unless(name and email and password)
		$("#signupbtn").html("Empty fields!!")
		setTimeout(setsignbtn, 1000);
		return
	$.ajax 
		url: '/signup'
		type: 'POST'
		data: {name : name, email : email, password : password}
		success: (response) ->
			if response.result == "success"
				$("#signupbtn").html("Check Mail")
			else 
				alert(response.result)
			setTimeout(setsignbtn, 2000);
		error: (error)->
			alert(error)
			setTimeout(setsignbtn, 2000);
	return

$("#loginbtn").click (event) ->
	event.preventDefault();
	$("#loginbtn").html("Logging you in ...")
	values = $(".loginform form:first-child input");
	email = values[0].value
	password = values[1].value
	unless(email and password)
		$("#loginbtn").html("Empty fields!!")
		setTimeout(loginbtn, 1000)
		return
	$.ajax
		url: '/login'
		type: 'POST'
		data: {email : email, password : password}
		success: (response) ->
			alert(response.result)
		error: (error) ->
			alert(error)
		setTimeout(setloginbtn, 2000)
	return