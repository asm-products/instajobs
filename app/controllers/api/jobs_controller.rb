class Api::JobsController < ApplicationController

	before_action :check_login

	def index
		@jobs = Job.all
		if params.include?(:user_id)
			@user_id = session[:user_id]["$oid"]
			@user = User.find(@user_id)
			@companies = @user.companies
			@jobs = []
			@companies.each do |c|
				c.jobs.each{|j| @jobs << j}
			end
		end
		render :json => @jobs
	end

	def create
		cp = createparams(params)
		@company = Company.find(cp[:companyid])
		@user_company = @company.user_id.to_s
		@user_id = session[:user_id]["$oid"]
		unless @user_id == @user_company
			render :json => {"result" => "error from here"}
		end
		@job = Job.new
		@job.title = cp[:title]
		@job.description = cp[:description]
		@job.salary = cp[:salary]
		@job.hours = cp[:hours]
		@job.location = [cp[:lat], cp[:lng]]
		@job.created_at = Time.now
		@job.save
		@company.jobs << @job
		if @company.save
			render :json => {"result" => "success", "id" => @job.id}
		else
			render :json => {"result" => "error"}
		end
	end

	private
	def check_login
		if session[:user_id].nil?
			redirect_to '/connect'
		end
	end
	def createparams(params)
		params.permit(:title, :description, :salary, :hours, :lat, :lng, :companyid)
	end

end
