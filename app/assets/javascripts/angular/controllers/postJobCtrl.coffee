do ->
	app = angular.module 'instajob'
	app.controller 'postJobCtrl', ['myjobs', 'mycompanies', '$scope', '$http', '$timeout', (myjobs, mycompanies, $scope, $http, $timeout) ->
		$scope.ncf = false; #show new company form
		$scope.njf = false; #show new job form
		$scope.ncfbtnval = "Create"; #button value of new company form
		$scope.njfbtnval = "Create"; #button value of new company form
		$scope.enjfbtnval = "Update"; #button value of new company form

		$scope.autoloc = false;
		$scope.eautoloc = false;
		$scope.lat = null;
		$scope.lng = null;

		$scope.editjob = null;

		$scope.myjobs = myjobs;
		unless $scope.myjobs
			$scope.myjobs = []
		$scope.mycompanies = mycompanies;
		$scope.showjobs = [];
		for j in $scope.myjobs
			$scope.showjobs.push(j);
		$scope.selectedc = null;
		$scope.updateJobs = (company) ->
			$scope.selectedc = company;
			$scope.showjobs = [];
			for j in $scope.myjobs
				company_id = j.companyid || j.company_id["$oid"]
				if company_id == company._id["$oid"]
					$scope.showjobs.push(j)
			return
		$scope.createCompany = (newcompany) ->
			$http.post('/api/companies', newcompany).then (response) ->
				if response.data.result == "success"
					$scope.ncfbtnval = "Created";
					newcompany._id = response.data.id;
					$scope.mycompanies.push(newcompany);
				else
					$scope.ncfbtnval = "Error";
				$timeout ()->
					$scope.ncfbtnval = "Create"
					$scope.ncf = false;
				,2000

		$scope.createJob = (newjob) ->
			unless($scope.selectedc)
				alert("Select a company")
				return
			newjob.companyid = $scope.selectedc._id["$oid"]
			if($scope.autoloc)
				newjob.lat = $scope.lat;
				newjob.lng = $scope.lng;
			$http.post('/api/jobs', newjob).then (response) ->
				if response.data.result == "success"
					$scope.njfbtnval = "Created"
					newjob.location = [newjob.lat, newjob.lng]
					newjob.id = response.data.id;
					$scope.myjobs.push(newjob);
					$scope.showjobs.push(newjob);
				else
					$scope.njfbtnval = "Error";
				$timeout () ->
					$scope.njfbtnval = "Create"
					$scope.njf = false;
				,2000

		showPosition = (position) ->
			$scope.lat = position.coords.latitude;
			$scope.lng = position.coords.longitude;
			$scope.$apply();
			return true

		$scope.toggleLatLng = () ->
			if($scope.autoloc)
				$scope.autoloc = false;
			else
				$scope.autoloc = true;
			if(navigator.geolocation)
				navigator.geolocation.getCurrentPosition(showPosition);
			else
				alert("Browser not supported");
			return true

		$scope.edit = (job) ->
			$scope.editjob = job;
			$scope.editjob.lat = $scope.editjob.location[0]
			$scope.editjob.lng = $scope.editjob.location[1]

		$scope.etoggleLatLng = () ->
			if($scope.eautoloc)
				$scope.eautoloc = false;
			else
				$scope.eautoloc = true;
			if(navigator.geolocation)
				navigator.geolocation.getCurrentPosition(showPosition);
			else
				alert("Browser not supported");
			return true

		$scope.updateJob = (editjob) ->
			if($scope.eautoloc)
				editjob.lat = $scope.lat;
				editjob.lng = $scope.lng;
			$scope.enjfbtnval = "Updating ...";
			editjob.companyid = editjob.company_id["$oid"]
			$http({url: '/api/jobs/'+editjob._id["$oid"], method: 'PATCH', data: editjob}).then (response) ->
				if response.data.result == "success"
					$scope.enjfbtnval = "Updated"
					editjob.location = [editjob.lat, editjob.lng]
					$timeout ()->
						$scope.enjfbtnval = "Update"
					,2000

		$scope.delete = (job) ->
			job.companyid = job.company_id["$oid"]
			$http({url: '/api/jobs/'+job._id["$oid"], method: 'DELETE', params: {companyid: job.companyid}}).then (response) ->
				if response.data.result == "success"
					delete job.companyid
					ind = $scope.myjobs.indexOf(job);
					$scope.myjobs.splice(ind, 1)
					ind = $scope.showjobs.indexOf(job);
					$scope.showjobs.splice(ind, 1)
	]
	return