should= require('chai').should()
# this is the compiled output from assembot, 
# use it like you would the 'window' object:
# buildenv= require('../public/flipbook')

# describe 'FlipBook', ->
#   #beforeEach ->
#   #afterEach ->

#   it 'should exist', ->
#     should.exist buildenv

#   it 'should contain the module loader', ->
#     buildenv.require.should.exist
#     buildenv.require.should.be.a.function

#   describe 'main', ->

#     it 'should exist', ->
#       main= buildenv.require('main')
#       should.exist main