do ->
	app = angular.module 'instajob'
	app.controller 'jobsNearCtrl', ["$http", "$scope", ($http, $scope) ->
		$scope.loading = true;
		$scope.lat = null;
		$scope.lng = null;

		getLatLng = () ->
			if(navigator.geolocation)
					navigator.geolocation.getCurrentPosition(showPosition);
			else
				alert("Browser not supported");

		showPosition = (position) ->
			$scope.lat = position.coords.latitude;
			$scope.lng = position.coords.longitude;
			$scope.$apply();
			$http({url: "/api/jobs", type: "GET", data : {lat: $scope.lat, lng: $scope.lng, radius: 100}}).then (response) ->
				$scope.loading = false;
			return true

		getLatLng();

	]
	return