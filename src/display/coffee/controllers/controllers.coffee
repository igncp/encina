define 'controllers/controllers', [
  'controllers/main'
  'controllers/home'
  'controllers/report/report'
  'controllers/report/extract'
  'controllers/report/conclusions'
], ()->
  controllers = arguments
  createControllers = (encina)->
    angular.forEach controllers, (controller)-> controller encina

  createControllers