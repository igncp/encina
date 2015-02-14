define 'factories/utils', [], ()->
  create = (encina)->
    gitHubRepoRegex = /^git@github.com:(.+?\/.+?)\.git$/

    encina.factory 'EncinaUtils', ->
      {
        nbrWCommas: (x, decimals = 0)->
          x = x.toFixed(decimals)
          parts = x.toString().split '.'
          final = parts[0] = parts[0].replace /\B(?=(\d{3})+(?!\d))/g, ','
          final = parts.join '.'

        split: (a, n)->
          if n is 0 then return a
          len = a.length; out = []; i = 0
          while i < len
            size = Math.ceil((len - i) / n--)
            out.push(a.slice(i, i += size))
          out

        launchModal: (number, id)->
          $('#modal-' + number + '-' + id).modal()
          false

        isGitHubRepo: (repoStr)-> gitHubRepoRegex.test repoStr

        transformGitRepoToGitHubUrl: (repoStr)->
          userAndRepo = gitHubRepoRegex.exec(repoStr)[1]
          'https://github.com/' + userAndRepo

        transformToGoogleSearchUrl: (queryStr)->
          'https://www.google.com/webhp?ie=UTF-8#q=' + queryStr
      }
      
  create