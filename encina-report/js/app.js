(function() {
  define('app', ['charts/charts'], function() {
    var encina;
    encina = angular.module('encina', []);
    encina.controller('MainCtrl', function($scope, $http) {
      return $http.get('data.json').then(function(res) {
        var extension, linesCount, size, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
        $scope.data = res.data;
        $scope.data.extensions.parsedHist = [];
        _ref = Object.keys($scope.data.extensions.hist);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          extension = _ref[_i];
          $scope.data.extensions.parsedHist.push({
            name: extension,
            count: $scope.data.extensions.hist[extension],
            percentage: (100 * $scope.data.extensions.hist[extension] / $scope.data.structure.total_files).toFixed(2)
          });
        }
        $scope.data.nel.parsedHist = [];
        $scope.data.nel.total = 0;
        _ref1 = Object.keys($scope.data.nel.hist);
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          linesCount = _ref1[_j];
          $scope.data.nel.total += linesCount * $scope.data.nel.hist[linesCount];
          $scope.data.nel.parsedHist.push({
            linesCount: Number(linesCount),
            filesCount: $scope.data.nel.hist[linesCount]
          });
        }
        $scope.data.sizes.parsedHist = [];
        $scope.data.sizes.total = 0;
        _ref2 = Object.keys($scope.data.sizes.hist);
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          size = _ref2[_k];
          $scope.data.sizes.total += size * $scope.data.sizes.hist[size] / 131072;
          $scope.data.sizes.parsedHist.push({
            size: size,
            filesCount: $scope.data.sizes.hist[size]
          });
        }
        $scope.treeString = JSON.stringify($scope.data.tree, void 0, 2);
        (require('charts/extensions-pie'))($scope.data.extensions.parsedHist);
        (require('charts/lines-distribution')).render($scope.data.nel.parsedHist);
        $scope.bsToKbs = function(size, decimals) {
          if (decimals == null) {
            decimals = 2;
          }
          return (size / 1000).toFixed(decimals) + ' kbs';
        };
        $scope.nbrWCommas = function(x) {
          var parts;
          parts = x.toString().split('.');
          parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
          return parts.join('.');
        };
        console.log('$scope.data', $scope.data);
        return $scope.loaded = function() {
          var container;
          container = document.getElementById('container');
          angular.element(container).css('opacity', 1);
          return false;
        };
      });
    });
    encina.directive('bootstrapAccordion', function() {
      return {
        restrict: 'E',
        templateUrl: 'components/bootstrap-accordion.html',
        replace: true,
        scope: {
          titleText: '@',
          expanded: '@',
          name: '@'
        },
        transclude: true
      };
    });
    return angular.bootstrap(document, ['encina']);
  });

}).call(this);
