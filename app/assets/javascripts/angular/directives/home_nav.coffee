app = angular.module 'instajob'
app.directive 'homeNav', () ->
	return{
		restrict: 'E',
		templateUrl: 'home_nav.html'
		controller: 'homeNavCtrl'}