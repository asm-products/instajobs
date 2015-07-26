do ->
	app = angular.module 'instajob'
	app.controller 'jobsCtrl', ['jobs', '$scope', '$http', '$rootScope', "$state", (jobs, $scope, $http, $rootScope, $state) ->
		$scope.jobs = jobs;
		$scope.selectedj = null;
		for j in $scope.jobs
			if j.description
				j.short_description = j.description.substring(0, Math.min(j.description.length, 140))
		$scope.addJob = (job) ->
			$http({url: '/api/addJob', params: {job_id: job._id["$oid"]}}).then (response) ->
				if response.data.result == "success"
					$rootScope.user_jobcount = parseInt($rootScope.user_jobcount) + 1;
		$scope.removeJob = (job) ->
			$http({url: '/api/removeJob', params: {job_id: job._id["$oid"]}}).then (response) ->
				if response.data.result == "success"
					$rootScope.user_jobcount = parseInt($rootScope.user_jobcount) - 1;
		$scope.selectedJob = (job) ->
			$scope.selectedj = job;
		$scope.gomatches = () ->
			$state.go("matches")
		$scope.gosavedjobs = ()->
			$state.go("savedjobs")
	]
	return