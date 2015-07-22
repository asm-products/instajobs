do ->
	app = angular.module 'instajob'
	app.controller 'candidatesCtrl', ["candidates", "$scope", "job", "$http", (candidates, $scope, job, $http) ->
		$scope.candidates = candidates;
		$scope.job = job;
		$scope.match = (candidate) ->
			$http({url: '/api/match', method: 'POST', data: {cid : candidate._id["$oid"], jid: $scope.job._id["$oid"]}}).then (response) ->
				if response.data.result == "success"
					alert("Saved match")

		$scope.removeMatch = (candidate) ->
			$http({url: '/api/removematch', method: 'POST', data: {cid: candidate._id["$oid"], jid: $scope.job._id["$oid"]}}).then (response) ->
				alert("Removed match")
	]
	return