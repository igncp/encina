define 'router', ->
  createRouter = (encina)->
    encina.config(($stateProvider, $urlRouterProvider, $locationProvider)->
      $locationProvider.html5Mode(
        enabled: true,
        requireBase: false
      )
      $urlRouterProvider.otherwise '/'
      $stateProvider.state('home', {
        url: '/'
        templateUrl: '/views/home.html'
        controller: 'HomeController'
      }).state('conclusions', {
        url: '/conclusions'
        templateUrl: '/views/conclusions.html'
        controller: 'ConclusionsCtrl'
      })
    )

  createRouter