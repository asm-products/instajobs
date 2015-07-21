do ->
	app = angular.module 'instajob'
	app.controller 'mainCtrl', ["$scope", "$rootScope", "ngProgressLite", ($scope, $rootScope, ngProgressLite) ->
		uname = document.getElementById('username').innerHTML;
		$rootScope.user_name = uname; 
		ujcount = document.getElementById('userjobsc').innerHTML;
		$rootScope.user_jobcount = ujcount;
		$rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
			ngProgressLite.start();
			return
		$rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      ngProgressLite.done();
      return
	]
	return