do ->
	app = angular.module 'instajob'
	app.controller 'matchesCtrl', ["matches", "$scope", (matches, $scope) -> 
		$scope.jobs = matches;
		$scope.selectedj = null;
		for j in $scope.jobs
			if j.description
				j.short_description = j.description.substring(0, Math.min(j.description.length, 140))
		$scope.selectedJob = (job) ->
			$scope.selectedj = job;
	]
	return