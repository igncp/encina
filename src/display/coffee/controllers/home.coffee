define 'controllers/home', ->
  createController = (encina)->
    encina.controller 'HomeCtrl', ($scope, $http, EncinaUtils)->
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

        $scope.notLastItem = (index, array)->
          if index isnt array.length - 1
            return 'not-last'
          else
            return 'last'

        $scope.colorsScale = (index, array)->
          colors = ['#F2F4FF', '#EAF9ED']
          c = d3.scale.linear().domain([0, array.length - 1]).range([0,1])
          colorScale = d3.scale.linear()
            .domain(d3.range(0, 1, 1.0 / (colors.length))).range(colors)
          scaleFn = (p)-> colorScale(c(p))
          scaleFn(index)


  createController