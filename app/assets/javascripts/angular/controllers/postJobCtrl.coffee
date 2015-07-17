do ->
	app = angular.module 'instajob'
	app.controller 'postJobCtrl', ['myjobs', 'mycompanies', '$scope', '$http', '$timeout', (myjobs, mycompanies, $scope, $http, $timeout) ->
		$scope.ncf = false; #show new company form
		$scope.njf = false; #show new job form
		$scope.ncfbtnval = "Create"; #button value of new company form
		$scope.njfbtnval = ""; #button value of new company form

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
	]
	return