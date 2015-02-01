define 'controllers/home', ->
  createController = (encina)->
    encina.controller 'HomeCtrl', ($scope, $http, EncinaFormatting)->
      $http.get('/reports-files').then (res)->
        files = res.data
        tempProjects = {}
        _.each files, (file)->
          projectName = file.substr 0, file.length - 11
          projectTimestamp = file.substr file.length - 10
          if tempProjects[projectName]
            tempProjects[projectName].push projectTimestamp
          else
            tempProjects[projectName] = [projectTimestamp]

        $scope.projects = []
        _.each Object.keys(tempProjects), (projectKey)->
          newProject =
            name: projectKey
            reports: tempProjects[projectKey]
          
          newProject.reports = _.map newProject.reports, (report)->
            date: moment.unix(report).format 'YYYY/MM/DD - HH:mm'
            name: report

          $scope.projects.push newProject

  createController