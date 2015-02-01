define 'controllers/main', ->
  createController = (encina)->
    encina.controller 'MainCtrl', ($scope)->
      console.log 'loaded main'

  createController