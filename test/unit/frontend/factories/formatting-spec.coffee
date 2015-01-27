expect = chai.expect

describe 'Formatting Spec', ->
  # @timeout 5000
  before (done)->
    require ['app'], -> done()
      
  describe 'EncinaFormatting', ->
    EncinaFormatting = ''

    beforeEach (done)->
      module 'encina'
      inject (_EncinaFormatting_)->
        EncinaFormatting = _EncinaFormatting_
        done()

    it 'is loaded', -> expect(EncinaFormatting).not.to.be.undefined

    describe 'nbrWCommas', ->
      it 'passes the formatting requirements', ->
        expectResult = (input, output, decimals)->
          expect(EncinaFormatting.nbrWCommas(input, decimals)).to.equal output
        expectResult 1000000, '1,000,000'
        expectResult 1000, '1,000'
        expectResult 10, '10'
        expectResult -10, '-10'
        expectResult -10000, '-10,000'
        expectResult 10.2, '10.20', 2
        expectResult -10000.29999, '-10,000.30', 2

    describe 'split', ->
      it 'acts as expected', ->
        expectResult = (inputArr, times, output)->
          expect(EncinaFormatting.split(inputArr, times)).to.eql output
        expectResult [1, 2], 0, [1, 2]
        expectResult [1, 2], 1, [[1, 2]]
        expectResult [1, 2], 2, [[1], [2]]
        expectResult [1, 2], 3, [[1], [2]]
        expectResult [1, 2, 3, 4, 5], 2, [[1, 2, 3], [4, 5]]
