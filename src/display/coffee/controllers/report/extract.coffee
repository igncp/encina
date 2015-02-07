define 'controllers/report/extract', ->
  createController = (encina)->
    encina.controller 'ExtractCtrl', ($scope, $timeout, EncinaFormatting)->
      runController = ->
        $scope.data = $scope.$parent.data

        $scope.nbrWCommas = EncinaFormatting.nbrWCommas

        renderCharts = ()->
          extensionsPie = require('charts/extensions-pie')
          extensionsData = $scope.data.extensions
          
          extensionsPie extensionsData.parsedHist, 'chart-extensions-pie-by-file', \
            'Extensions by total number of Files (' + \
            $scope.nbrWCommas($scope.data.structure.total_files) + ')', 'files'
          
          extensionsPie extensionsData.hist_by_nel, 'chart-extensions-pie-by-nel', \
            'Extensions by total Non Empty Lines (' + \
              $scope.nbrWCommas($scope.data.nel.index_total) + ')', 'Non Empty Lines'

          extensionsPie extensionsData.hist_by_size, 'chart-extensions-pie-by-size', \
            'Extensions grouped by total size (' + $scope.data.sizes.totalMbs + ' Mbs)', 'kbs'

          (require('charts/lines-distribution'))($scope.data.nel.parsedHist)
          (require('charts/depths-distribution'))($scope.data.depths.parsedHist)

        renderCharts()

      waitTillDataLoaded = ->
        if $scope.$parent.data then runController()
        else $timeout(waitTillDataLoaded, 50)
      waitTillDataLoaded()

  createController
