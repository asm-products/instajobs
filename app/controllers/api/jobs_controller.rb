class Api::JobsController < ApplicationController

	before_action :check_login

	def index
		@jobs = Job.all
		if params.include?(:user_id)
			@user_id = session[:user_id]["$oid"]
			@user = User.find(@user_id)
			@companies = @user.companies
			@jobs = []
			@companies.each{|c| @jobs << c.jobs}
		end
		render :json => @jobs
	end

	private
	def check_login
		if session[:user_id].nil?
			redirect_to '/connect'
		end
	end

end
