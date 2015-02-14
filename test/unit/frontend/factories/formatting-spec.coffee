expect = chai.expect

describe 'Formatting Spec', ->
  # @timeout 5000
  before (done)->
    require ['app'], -> done()
      
  describe 'EncinaUtils', ->
    EncinaUtils = ''

    beforeEach (done)->
      module 'encina'
      inject (_EncinaUtils_)->
        EncinaUtils = _EncinaUtils_
        done()

    it 'is loaded', -> expect(EncinaUtils).not.to.be.undefined

    describe 'nbrWCommas', ->
      it 'passes the formatting requirements', ->
        expectResult = (input, output, decimals)->
          expect(EncinaUtils.nbrWCommas(input, decimals)).to.equal output
        expectResult 1000000, '1,000,000'
        expectResult 1000, '1,000'
        expectResult 10, '10'
        expectResult -10, '-10'
        expectResult -10000, '-10,000'
        expectResult 10.2, '10.20', 2
        expectResult -10000.29999, '-10,000.30', 2

    describe 'split', ->
      it 'passes the requirements', ->
        expectResult = (inputArr, times, output)->
          expect(EncinaUtils.split(inputArr, times)).to.eql output
        expectResult [1, 2], 0, [1, 2]
        expectResult [1, 2], 1, [[1, 2]]
        expectResult [1, 2], 2, [[1], [2]]
        expectResult [1, 2], 3, [[1], [2]]
        expectResult [1, 2, 3, 4, 5], 2, [[1, 2, 3], [4, 5]]

    describe 'isGitHubRepo', ->
      it 'passes the requirements', ->
        expectResult = (repoStr, output)-> expect(EncinaUtils.isGitHubRepo(repoStr)).to.be[output]
        expectResult 'git@github.com:igncp/encina.git', true
        expectResult 'git@notgithub.com:igncp/encina.git', false

    describe 'transformGitRepoToGitHubUrl', ->
      it 'passes the requirements', ->
        expectResult = (repoStr, output)->
          expect(EncinaUtils.transformGitRepoToGitHubUrl(repoStr)).to.equal output
        expectResult 'git@github.com:igncp/encina.git', 'https://github.com/igncp/encina'