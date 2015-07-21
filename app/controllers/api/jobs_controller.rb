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
		if params.include?(:lat)
			lat = params[:lat]
			lng = params[:lng]
			radius = params[:radius]
			@jobs = Job.geo_near([lat.to_f, lng.to_f]).max_distance(radius.to_f)
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
			return
		end
		@job = Job.new
		@job.title = cp[:title]
		@job.description = cp[:description]
		@job.salary = cp[:salary]
		@job.hours = cp[:hours]
		@job.responsibility = cp[:responsibility]
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

	def update
		up = updateparams(params)
		@job = Job.find(up[:id].to_s)
		@companyid = up[:companyid]
		@user_id = session[:user_id]["$oid"]
		@company = Company.find(@companyid)
		unless @company.user_id.to_s == @user_id
			render :json => {"result" => "not authorized"}
			return
		end
		unless @job
			render :json => {"result" => "job not found"}
			return
		end
		@job.title = up[:title]
		@job.description = up[:description]
		@job.salary = up[:salary]
		@job.hours = up[:hours]
		@job.responsibility = up[:responsibility]
		@job.location = [up[:lat], up[:lng]]
		if @job.save
			render :json => {"result" => "success"}
		else
			render :json => {"result" => "error"}
		end
	end

	def destroy
		dp = deleteparams(params)
		@job = Job.find(dp[:id].to_s)
		@companyid = dp[:companyid]
		@user_id = session[:user_id]["$oid"]
		@company = Company.find(@companyid)
		unless @company.user_id.to_s == @user_id
			render :json => {"result" => "not authorized"} 
		end
		unless @job
			render :json => {"result" => "job not found"}
			return
		end
		if @job.destroy
			render :json => {"result" => "success"}
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

	def updateparams(params)
		params.permit(:id, :title, :description, :salary, :hours, :lat, :lng, :companyid, :responsibility)
	end

	def createparams(params)
		params.permit(:title, :description, :salary, :hours, :lat, :lng, :companyid, :responsibility)
	end

	def deleteparams(params)
		params.permit(:id, :companyid)
	end

end
