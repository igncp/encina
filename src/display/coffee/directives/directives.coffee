define 'directives/directives', [
  'directives/summary-statistics'
  'directives/bootstrap-accordion'
  'directives/bootstrap-modal'
  'directives/bootstrap-modal-default-list'
], ()->
  directives = arguments
  createDirectives = (encina)->
    angular.forEach directives, (directive)-> directive(encina)

  createDirectives