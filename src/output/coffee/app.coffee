define 'app', [
  'router'
  'controllers/controllers'
  'directives/directives'
  'charts/charts'
], (router, controllers, directives)->
  encina = angular.module 'encina', ['ui.router']
  
  router encina
  controllers encina
  directives encina

  angular.bootstrap document, ['encina']