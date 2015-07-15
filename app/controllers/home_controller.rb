class HomeController < ApplicationController
	require 'bcrypt'
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
  	if(User.where(:email => @u.email).size != 0)
  		render :json => {result: "email already registered"}
  		return
  	end
  	@u.password = BCrypt::Password.create(sparams[:password])
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

  end

  def verify
  	token = params[:token]
  	
  end

  private 
  def signup_params(params)
  	params.permit(:name, :email, :password)
  end
end