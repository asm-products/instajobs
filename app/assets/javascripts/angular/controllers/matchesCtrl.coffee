do ->
	app = angular.module 'instajob'
	app.controller 'matchesCtrl', ["matches", "$scope", (matches, $scope) -> 
		$scope.jobs = matches;
	]
	return