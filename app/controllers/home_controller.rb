class HomeController < ApplicationController
	require 'securerandom'

	layout 'application'

  def landing
  	render template: "home/landing", layout: false
  end

  def connect
    unless session[:user_id].nil?
      redirect_to '/dashboard'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/connect'
  end

  def fb
  	fbparam = fbparams(params)
  	newsignup = false
  	@u = User.where(:email => fbparam[:email]).first
  	if @u
  		@u.facebook_profile = FacebookProfile.new(:uid => fbparam[:id], :access_token => fbparam[:access_token])
  	else
  		@u = User.new
  		@u.name = fbparam[:name]
  		@u.email = fbparam[:email]
  		@u.email_verified = true
  		@u.password = SecureRandom.hex(6)
  		@u.facebook_profile = FacebookProfile.new(:uid => fbparam[:id], :access_token => fbparam[:access_token])
  		newsignup = true
  	end
  	if @u.save
  		if newsignup
  			# TODO move mailer to background queue
		  	FbSignupMailer.password(@u).deliver
  		end
	  	session[:user_id] = @u.id
			render :json => {result: "success"}
  	else
  		render :json => {result: "save error" + @u.errors.join(" ")}
  	end
  end

  def genpassword
    @email = params[:email]
    @user = User.where(:email => @email).first
    unless @user
      render :json => {result: "user not found"}
    end
    @user.password = SecureRandom.hex(6)
    if @user.save
      FbSignupMailer.password(@user).deliver
      render :json => {result: "success"}
    else
      render :json => {result: "save error"}
    end
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
  	verify_token = SecureRandom.urlsafe_base64
  	while(User.where(:email_verify_token => verify_token).size != 0)
  		verify_token = SecureRandom.urlsafe_base64
  	end
  	@u.email_verify_token = verify_token
    @u.jobmatches = []
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
  			render :json => {result: "success"}
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
      redirect_to "/connect"
  	end
  end

  private 
  def signup_params(params)
  	params.permit(:name, :email, :password)
  end

  def login_params(params)
  	params.permit(:email, :password)
  end

  def fbparams(params)
  	params.permit(:email, :name, :id, :access_token)
  end

end