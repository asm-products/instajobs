do ->
	app = angular.module 'instajob'
	app.controller 'postJobCtrl', ['myjobs', 'mycompanies', '$scope', '$http', '$timeout', (myjobs, mycompanies, $scope, $http, $timeout) ->
		$scope.ncf = false; #show new company form
		$scope.njf = false; #show new job form
		$scope.ncfbtnval = "Create"; #button value of new company form
		$scope.njfbtnval = ""; #button value of new company form

		$scope.autoloc = false;
		$scope.lat = null;
		$scope.lng = null;

		$scope.myjobs = myjobs;
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

		
	]
	return