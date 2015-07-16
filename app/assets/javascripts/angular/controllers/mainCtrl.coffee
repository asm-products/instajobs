app = angular.module 'instajob'
app.controller 'mainCtrl', ["$scope", "$rootScope", ($scope, $rootScope) ->
	uname = document.getElementById('username').innerHTML;
	$rootScope.user_name = uname; 
]