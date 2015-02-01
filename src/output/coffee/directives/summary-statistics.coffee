define 'directives/summary-statistics', [], ()->
  create = (encina)->
    encina.directive 'summaryStatistics', (EncinaFormatting)->
      return {
        restrict: 'E'
        templateUrl: '/components/summary-statistics.html'
        replace: true
        scope:
          varTitle: '@'
          dirs: '@'
          varName: '@'
          toKbs: '@'
          integersIndex: '@'
          jsonData: '='
        transclude: true
        link: (scope, elem, attr)->
          scope.FoD = if scope.dirs then 'dir' else 'file' # File or Dir
          scope.exists = (dataProp)->
            if scope.jsonData
              propertyIsPresent = if eval('scope.jsonData.' + dataProp)  then true else false
              return propertyIsPresent
            else return false

          scope.parseNumber = (dataProp, decimals, opts={})->
            if scope.jsonData
              # Defaults
              if typeof decimals is 'undefined'
                decimals = if scope.integersIndex is 'true' then 0 else 2
              
              setOptsDefaults = (defaults)->
                angular.forEach defaults, (defaultVal)->
                  opts[defaultVal[0]] = if typeof opts[defaultVal[0]] isnt 'undefined' then \
                    opts[defaultVal[0]] else defaultVal[1]
              
              setOptsDefaults [['isFile', false], ['toKbs', 'default'], ['toMbs', false]]

              propValue = eval 'scope.jsonData.' + dataProp
              
              if (scope.toKbs is 'true') and (decimals isnt 0) and \
                (opts.toKbs isnt false) and (opts.isFile isnt true) then propValue /= 1000

              final = EncinaFormatting.nbrWCommas propValue, decimals
              
              if (scope.toKbs is 'true') and (decimals isnt 0) and (opts.isFile isnt true)
                final += if opts.toMbs isnt true then ' kbs' else ' mbs'

              return final

            else return 'waiting...' # The data is not loaded yet
          
          scope.launchModal = (number, id)->
            $('#modal-' + number + '-' + id).modal()
            false

          scope.getPaths = (dataProp)->
            if scope.jsonData
              propValue = eval 'scope.jsonData.' + dataProp
              return if propValue then propValue else false
            else return false
      }
  create