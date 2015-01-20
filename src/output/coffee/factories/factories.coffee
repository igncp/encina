define 'factories/factories', [
  'factories/formatting'
], ()->
  factories = arguments
  createFactories = (encina)->
    angular.forEach factories, (factory)-> factory(encina)

  createFactories