do ->
	app = angular.module 'instajob'
	app.controller 'jobsNearCtrl', ["$http", "$scope", "uiGmapGoogleMapApi", ($http, $scope, uiGmapGoogleMapApi) ->
		$scope.loading = true;
		$scope.lat = null;
		$scope.lng = null;
		$scope.jobs = null;
		$scope.radius = 5;

		getLatLng = () ->
			if(navigator.geolocation)
					navigator.geolocation.getCurrentPosition(showPosition);
			else
				alert("Browser not supported");

		showPosition = (position) ->
			$scope.lat = position.coords.latitude;
			$scope.lng = position.coords.longitude;
			$scope.$apply();
			$http({url: "/api/jobs", method: "GET", params : {lat: $scope.lat, lng: $scope.lng, radius: $scope.radius}}).then (response) ->
				$scope.loading = false;
				$scope.jobs = response.data;
				initailizeMap();
			return true

		getLatLng();

		initailizeMap = () ->
			$scope.map = { center: { latitude: $scope.lat, longitude: $scope.lng }, zoom: 12 };
			$scope.marker = {
				id: 0,
				coords: {
					latitude: $scope.lat,
					longitude: $scope.lng
				},
				options: {
					icon: "/map-marker-me.png",
				}
			};
			$scope.markers = {
				options:{
					icon: "/map-marker-icon.png"
				}
			}
			for j, index in $scope.jobs
				j.id = index + 1;
				j.coords = {
					latitude: j.location[0],
					longitude: j.location[1],
				}
				j.description = j.description.substring(0, Math.min(j.description.lenght, 240))
				# console.log(j.coords)
		
		$scope.slider = 'options':
		  start: (event, ui) ->
		    # console.log 'he'
		    return
		  stop: (event, ui) ->
		  	$scope.loading = true;
		  	$http({url: "/api/jobs", method: "GET", params : {lat: $scope.lat, lng: $scope.lng, radius: $scope.radius}}).then (response) ->
						$scope.loading = false;
						$scope.jobs = response.data;
						initailizeMap();
	]
	return