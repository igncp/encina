define 'controllers/report/extract', ->
  createController = (encina)->
    encina.controller 'ExtractCtrl', ($scope, $timeout, EncinaUtils)->
      runController = ->
        $scope.data = $scope.$parent.data

        $scope.nbrWCommas = EncinaUtils.nbrWCommas

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
          (require('charts/structure-radial-graph'))($scope.data.tree, 'structure-radial-graph')

        renderCharts()

        $scope.git = $scope.data.special.git
        if $scope.git
          if typeof $scope.git.remote is 'string'
            if EncinaUtils.isGitHubRepo $scope.git.remote
              remoteLink = EncinaUtils.transformGitRepoToGitHubUrl $scope.git.remote
            else
              remoteLink = EncinaUtils.transformToGoogleSearchUrl $scope.git.remote
            $scope.git.remote =
              name: $scope.git.remote
              link: remoteLink

        $scope.launchModal = EncinaUtils.launchModal

        console.log '$scope.data', $scope.data

      waitTillDataLoaded = ->
        if $scope.$parent.data then runController()
        else $timeout(waitTillDataLoaded, 50)
      waitTillDataLoaded()

  createController
