class Api::JobsController < ApplicationController

	before_action :check_login

	def index
		@jobs = Job.order("created_at DESC")
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
			render :json => {jobs: @jobs, address: Geocoder.address([lat.to_f, lng.to_f])}
			return
		elsif params.include?(:address)
			address = params[:address]
			lat, lng = Geocoder.coordinates(address);
			radius = params[:radius]
			@jobs = Job.geo_near([lat.to_f, lng.to_f]).max_distance(radius.to_f)
			render :json => {jobs: @jobs, lat: lat, lng: lng}
			return
		end
		render :json => {result: "no params match"}
	end

	def show
		@jobid = params[:id]
		@job = Job.find(@jobid)
		unless @job
			render :json => {"result" => "job not found"}
		end
			render :json => @job
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
		@job.jobmatches = []
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

	def addJob
		@user_id = session[:user_id]["$oid"]
		@user = User.find(@user_id)
		@job = Job.find(params[:job_id])
		if @user.jobs.include?(@job)
			render :json => {"result" => "already added"}
		else
			@user.jobs << @job;
			@user.jobmatches << 0;
			@job.jobmatches << 0;
			@job.save
			@user.save;
			render :json => {"result" => "success"}
		end
	end

	def removeJob
		@user_id = session[:user_id]["$oid"]
		@user = User.find(@user_id)
		@job = Job.find(params[:job_id])
		if @user.jobs.include?(@job)
			@ind = @user.jobs.index(@job);
			@user.jobs.delete(@job)
			@user.jobmatches.delete_at(@ind)
			@ind = @job.users.index(@user)
			@job.users.delete_at(@ind)
			@job.jobmatches.delete_at(@ind)
			@job.save
			@user.save
			render :json => {"result" => "success"}
		else
			render :json => {"result" => "job not saved"}
		end
	end

	def candidates
		@jobid = params[:jobid]
		@job = Job.find(@jobid)
		@users = @job.users
		unless @job
			render :json => {"result" => "job not found"}
		end
		render :json => @users
	end

	def match
		@candidate_id = params[:cid]
		@candidate = User.find(@candidate_id)
		@job_id = params[:jid]
		@job = Job.find(@job_id)
		@user_id = session["user_id"]["$oid"]
		@user = User.find(@user_id)
		@company = @job.company
		unless @company.user_id.to_s == @user_id
			render :json => {"result" => "not authorized"}
			return
		end
		@ind = @job.users.index(@candidate)
		@job.jobmatches[@ind] = 1
		@job.save
		@ind = @candidate.jobs.index(@job)
		@candidate.jobmatches[@ind] = 1
		@candidate.save
		render :json => {"result" => "success"}
	end

	def removematch
		@candidate_id = params[:cid]
		@candidate = User.find(@candidate_id)
		@job_id = params[:jid]
		@job = Job.find(@job_id)
		@user_id = session["user_id"]["$oid"]
		@user = User.find(@user_id)
		@company = @job.company
		unless @company.user_id.to_s == @user_id
			render :json => {"result" => "not authorized"}
			return
		end
		@ind = @job.users.index(@candidate)
		@job.jobmatches[@ind] = 0
		@job.save
		@ind = @candidate.jobs.index(@job)
		@candidate.jobmatches[@ind] = 0
		@candidate.save
		render :json => {"result" => "success"}
	end

	def mymatches
		@user_id = session["user_id"]["$oid"]
		@user = User.find(@user_id)
		@jobs = []
		for i in (0...(@user.jobs.size))
			if @user.jobmatches[i] == 1
				@jobs << @user.jobs[i]
			end
		end
		render :json => @jobs
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
