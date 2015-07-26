class Api::UsersController < ApplicationController

	before_action :check_login
	
	def index
		@user_id = session["user_id"]["$oid"]
		@user = User.find(@user_id)
		if @user
			render :json => @user
		else
			render :json => {result: "user not found"}
		end
	end

	def update
		up = updateparams(params)
		@user_id = session["user_id"]["$oid"]
		@user = User.find(@user_id)
		if @user
			@user.password = up[:password]
			@user.name = up[:name]
			if @user.save
				render :json => {result: "success"}
			else
				render :json => {result: "save error"}
			end
		else
			render :json => {result: "user not found"}
		end
	end

	def savedjobs
		@user_id = session[:user_id]["$oid"]
		@user = User.find(@user_id)
		if @user
			render :json => @user.jobs
		else
			render :json => {result: "user not found"}
		end
	end

	private
	def check_login
		if session[:user_id].nil?
			redirect_to '/connect'
		end
	end

	def updateparams(params)
		params.permit(:name, :password)
	end
end
