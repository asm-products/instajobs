do ->
	app = angular.module 'instajob'
	app.controller 'profileCtrl', ["$http", "user", "$timeout", "$scope", "$rootScope", ($http, user, $timeout, $scope, $rootScope) ->
		$scope.user = user;
		$scope.submitbtnval = "Update";
		$scope.updateUser = (user) ->
			$scope.submitbtnval = "Updating ...";
			$http({url: '/api/user', method: "POST", data: user}).then (response) ->
				if(response.data.result == "success")
					$scope.submitbtnval = "Updated";
					$rootScope.user_name = user.name;
				else
					$scope.submitbtnval = "Error";
				$timeout () ->
					$scope.submitbtnval = "Update";
				,2000	
	]
	return