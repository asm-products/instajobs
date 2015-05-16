instajobs = angular.module('instajobs',[
  'templates',
  'ngRoute',
  'controllers',
])

instajobs.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'JobsController'
      )
])

jobs = [
  {
    id: 1
    name: 'Developer Level 1'
  },
  {
    id: 2
    name: 'Engineer Level 2',
  },
  {
    id: 3
    name: 'Developer Level 2',
  },
  {
    id: 4
    name: 'Dev Level 4',
  },
]
controllers = angular.module('controllers',[])
controllers.controller("JobsController", [ '$scope', '$routeParams', '$location',
  ($scope,$routeParams,$location)->
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)

    if $routeParams.keywords
      keywords = $routeParams.keywords.toLowerCase()
      $scope.jobs = jobs.filter (job)-> job.name.toLowerCase().indexOf(keywords) != -1
    else
      $scope.jobs = []
])