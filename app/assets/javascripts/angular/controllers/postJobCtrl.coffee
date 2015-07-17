do ->
	app = angular.module 'instajob'
	app.controller 'postJobCtrl', ['myjobs', 'mycompanies', '$scope', '$http', '$timeout', (myjobs, mycompanies, $scope, $http, $timeout) ->
		$scope.ncf = false; #show new company form
		$scope.njf = true; #show new job form
		$scope.ncfbtnval = "Create"; #button value of new company form
		$scope.njfbtnval = ""; #button value of new company form

		$scope.lat = null;
		$scope.lng = null;

		$scope.myjobs = myjobs;
		$scope.mycompanies = mycompanies;
		$scope.showjobs = [];
		if $scope.myjobs.size > 0
			for j in $scope.myjobs
				$scope.showjobs.push(j);
		$scope.selectedc = null;
		$scope.updateJobs = (company) ->
			$scope.selectedc = company;
			$scope.showjobs = [];
			if $scope.myjobs.size > 0
				for j in $scope.myjobs
					if j[0].company_id["$oid"] == company._id["$oid"]
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

		showPosition = (position) ->
			$scope.lat = position.coords.latitude;
			$scope.lng = position.coords.longitude;
			console.log($scope.lat)
			console.log($scope.lng)
			return 

		$scope.findLatLng = () ->
			if(navigator.geolocation)
				navigator.geolocation.getCurrentPosition(showPosition);
			else
				alert("Browser not supported");
			return 

		
	]
	return