srcPath = '../../../../encina/src/output/coffee/'
cloudflarePath = 'http://cdnjs.cloudflare.com/ajax/libs/'

config =
  basePath: ''
  frameworks: ['mocha', 'chai']
  files: [
    cloudflarePath + 'async/0.9.0/async.js'
    cloudflarePath + 'moment.js/2.8.4/moment.min.js'
    cloudflarePath + 'jquery/2.1.1/jquery.min.js'
    cloudflarePath + 'jqueryui/1.11.2/jquery-ui.min.js'
    cloudflarePath + 'lodash.js/2.4.1/lodash.min.js'
    'http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js'
    cloudflarePath + 'angular.js/1.3.3/angular.js'
    cloudflarePath + 'angular.js/1.3.3/angular-mocks.js'
    cloudflarePath + 'angular-ui-router/0.2.13/angular-ui-router.min.js'
    cloudflarePath + 'd3/3.4.13/d3.min.js'
    'https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.15/require.min.js'
    
    srcPath + '**/*.coffee'
    
    '**/*-spec.coffee'
  ]
  exclude: []
  preprocessors: {
    '**/*-spec.coffee': 'coffee'
  }
  coffeePreprocessor: {
    # options passed to the coffee compiler
    options: {
      bare: true
      sourceMap: false
    }
    # transforming the filenames
    transformPath: (path)-> path.replace(/\.coffee$/, '.js')
  }
  
  reporters: ['progress'] # dots

  port: 9876
  colors: true
  autoWatch: true
  browsers: ['PhantomJS']
  singleRun: false
  plugins: [
    'karma-mocha'
    'karma-chai'
    'karma-phantomjs-launcher'
    'karma-coffee-preprocessor'
  ]

config.preprocessors[srcPath + '**/*.coffee'] = 'coffee'

module.exports = (karma) ->
  config.logLevel = karma.LOG_INFO
  karma.set config
    