define 'controllers/controllers', [
  'controllers/main'
  'controllers/home'
  'controllers/conclusions'
], ()->
  controllers = arguments
  createControllers = (encina)->
    angular.forEach controllers, (controller)-> controller encina

  createControllers