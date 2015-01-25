expect = chai.expect
describe 'FOO', ->
  it 'BAR', (done)->
    require ['app'], (encina)->
      expect(1).to.equal 1
      done()