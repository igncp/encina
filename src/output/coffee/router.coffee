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
        controller: 'HomeCtrl'
      }).state('report', {
        url: '/report/:report'
        abstract: true
        templateUrl: '/views/report/report.html'
        controller: 'ReportCtrl'
      }).state('report.extract', {
        url: ''
        templateUrl: '/views/report/extract.html'
        controller: 'ExtractCtrl'
      }).state('report.conclusions', {
        url: '/conclusions'
        templateUrl: '/views/report/conclusions.html'
        controller: 'ExtractCtrl'
      })
    )

  createRouter