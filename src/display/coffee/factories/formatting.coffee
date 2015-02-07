define 'factories/formatting', [], ()->
  create = (encina)->
    encina.factory 'EncinaFormatting', ->
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
      }
      
  create