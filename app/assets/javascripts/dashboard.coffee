do ->
	app = angular.module 'instajob', [ 'ngProgressLite', 'templates', 'ui.router', 'uiGmapgoogle-maps', 'ui.slider'];
	app.config ['$httpProvider', '$stateProvider', '$urlRouterProvider', ($httpProvider, $stateProvider, $urlRouterProvider) -> 
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    return
  ];
 app.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  	$urlRouterProvider.otherwise('/');
  	$stateProvider.state 'jobs', {
  		url: '/',
  		templateUrl: 'jobs.html',
  		controller: 'jobsCtrl',
  		resolve: {
  			jobs: ["$http", ($http) ->
  				return $http.get('/api/jobs').then (response) ->
  					return response.data;
  			]
  		}
  	};
    
   $stateProvider.state 'postjob', {
      url: '/postjob',
      templateUrl: 'postjob.html',
      controller: 'postJobCtrl',
      resolve:{
        myjobs: ["$http", ($http) -> 
          return $http({ url : '/api/jobs', method : 'GET', params: {user_id : true}}).then (response) ->
            return response.data;
        ],
        mycompanies: ["$http", ($http) -> 
          return $http({url: '/api/companies', method : 'GET', params: {user_id : true}}).then (response) ->
            return response.data;
        ]
      }
    };
    
   $stateProvider.state 'jobsnear', {
      url: '/jobsnear',
      templateUrl: 'jobsnear.html',
      controller: 'jobsNearCtrl',
    };

  ];
	return