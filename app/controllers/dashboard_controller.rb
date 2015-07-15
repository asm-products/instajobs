class DashboardController < ApplicationController
	#check login 
	before_action :check_login

	def index

	end

	private 
	def check_login
		if session[:user_id].nil?
			redirect_to '/connect'
		end
	end

end
