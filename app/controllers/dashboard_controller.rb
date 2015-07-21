class DashboardController < ApplicationController
	#check login 
	before_action :check_login

	def index
		@user_id = session[:user_id]["$oid"]
		@user = User.find(@user_id)
		@user_name = @user.name
		@user_jobcount = @user.jobs.count
	end

	private 
	def check_login
		if session[:user_id].nil?
			redirect_to '/connect'
		end
	end

end
