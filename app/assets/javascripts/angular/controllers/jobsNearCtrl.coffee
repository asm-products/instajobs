do ->
	app = angular.module 'instajob'
	app.controller 'jobsNearCtrl', ["$http", "$scope", "uiGmapGoogleMapApi", "$rootScope", "$state", ($http, $scope, uiGmapGoogleMapApi, $rootScope, $state) ->
		$scope.loading = true;
		$scope.lat = null;
		$scope.lng = null;
		$scope.jobs = null;
		$scope.radius = 5;
		$scope.selectedj = null;
		$scope.mapv = false;
		$scope.infowindowjob = null;

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
				if j.description
					j.short_description = j.description.substring(0, Math.min(j.description.lenght, 140))
		
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

		$scope.markersEvents = 
			"mouseover" : (gMarker, eventname, model) ->
				$scope.infowindowjob = model;
				$(".infowindow").fadeIn();
			"mouseout" : (gMarker, eventname, model) ->

		$scope.markerEvent = 
			"mouseover" : (gMarker, eventname, model) ->
				return 
			"mouseout" : (gMarker, eventname, model) ->
				return

		$scope.addJob = (job) ->
			$http({url: '/api/addJob', params: {job_id: job._id["$oid"]}}).then (response) ->
				if response.data.result == "success"
					$rootScope.user_jobcount = parseInt($rootScope.user_jobcount) + 1;
					alert("Added to Saved Jobs")
		$scope.removeJob = (job) ->
			$http({url: '/api/removeJob', params: {job_id: job._id["$oid"]}}).then (response) ->
				if response.data.result == "success"
					$rootScope.user_jobcount = parseInt($rootScope.user_jobcount) - 1;
					alert("Added to Saved Jobs")

		$scope.selectedJob = (job) ->
			$scope.selectedj = job

		$scope.gomatches = () ->
			$state.go("matches")
		$scope.gosavedjobs = ()->
			$state.go("savedjobs")
	]
	return