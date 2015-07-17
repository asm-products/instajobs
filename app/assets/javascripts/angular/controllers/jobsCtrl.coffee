do ->
	app = angular.module 'instajob'
	app.controller 'jobsCtrl', ['jobs', '$scope', (jobs, $scope) ->
		$scope.jobs = jobs;
		console.log($scope.jobs);
	]
	return