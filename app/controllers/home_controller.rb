class HomeController < ApplicationController
	require 'securerandom'

	layout 'application'

  def landing
  	render template: "home/landing", layout: false
  end

  def connect
  
  end

  def signup
  	sparams = signup_params(params)
  	@u = User.new()
  	@u.name = sparams[:name]
  	@u.email = sparams[:email]
  	@u.password = sparams[:password]
  	if(User.where(:email => @u.email).size != 0)
  		render :json => {result: "email already registered"}
  		return
  	end
  	verify_token = SecureRandom.hex
  	while(User.where(:email_verify_token => verify_token).size != 0)
  		verify_token = SecureRandom.hex
  	end
  	@u.email_verify_token = verify_token
  	if @u.save
	  	# TODO move mailer to background queue
	  	SignupMailer.signup_link(@u).deliver
	  	render :json => {result: "success"}
  	else
	  	render :json => @u.errors
  	end
  end

  def login
  	lparams = login_params(params)
  	@u = User.where(:email => lparams[:email]).first
  	if !@u
  		render :json => {result: "no user with this email"}
  	else
  		pass = lparams[:password]
  		unless @u.email_verified
  			render :json => {result: "email not verified"}
  			return
  		end
  		if @u.authenticate(pass)
  			session[:user_id] = @u.id
  			redirect_to '/dashboard'
  		else
  			render :json => {result: "password did not match"}
  		end
  	end
  end

  def verify
  	token = params[:token]
  	@u = User.where(:email_verify_token => token).first
  	if !@u
  		render :json => {result: "invalid token"} 
  	else 
  		@u.email_verified = true
  		@u.save
   		render :json => {result: "email verified, you can now login to site"}
  	end
  end

  private 
  def signup_params(params)
  	params.permit(:name, :email, :password)
  end

  def login_params(params)
  	params.permit(:email, :password)
  end
end