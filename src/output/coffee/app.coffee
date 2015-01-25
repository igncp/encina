define 'app', [
  'router'
  'factories/factories'
  'controllers/controllers'
  'directives/directives'
  'charts/charts'
], (router, factories, controllers, directives)->
  encina = angular.module 'encina', ['ui.router']
  
  router encina
  factories encina
  controllers encina
  directives encina

  angular.bootstrap document, ['encina']

  encina