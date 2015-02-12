define 'factories/factories', [
  'factories/utils'
], ()->
  factories = arguments
  createFactories = (encina)->
    angular.forEach factories, (factory)-> factory(encina)

  createFactories