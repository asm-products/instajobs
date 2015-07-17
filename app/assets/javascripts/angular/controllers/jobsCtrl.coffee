do ->
	app = angular.module 'instajob'
	app.controller 'jobsCtrl', ['jobs', '$scope', (jobs, $scope) ->
		$scope.jobs = jobs;
		for j in $scope.jobs
			j.description = j.description.substring(0, Math.min(j.description.length, 240))
	]
	return