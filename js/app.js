(function() {
  define('app', [], function() {
    var encinaSite;
    encinaSite = angular.module('encinaSite', []);
    encinaSite.controller('MainCtrl', function($scope) {
      return $scope.loaded = function() {
        var el;
        el = document.getElementById('container');
        angular.element(el).css('opacity', 1);
        return false;
      };
    });
    return angular.bootstrap(document, ['encinaSite']);
  });

}).call(this);
