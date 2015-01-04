(function() {
  define('app', [], function() {
    var encinaSite;
    encinaSite = angular.module('encinaSite', []);
    encinaSite.controller('MainCtrl', function($scope) {
      return angular.element(document).ready(function() {
        var show;
        show = function(elId) {
          var el;
          el = document.getElementById(elId);
          return angular.element(el).css('opacity', 1);
        };
        show('container');
        show('footer');
        return false;
      });
    });
    return angular.bootstrap(document, ['encinaSite']);
  });

}).call(this);
