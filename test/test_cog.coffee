{expect}= chai= require 'chai'
should= chai.should()

Cog= require('../source/cog/object')

describe 'Cog', ->

  describe 'Object', ->

    it 'should exist', ->
      should.exist Cog

    it 'should accept initial attributes via constructor', ->
      o= new Cog name:'test'
      should.exist o.name
      should.exist o.get
      should.exist o.set
      o.get.should.be.a.function
      o.set.should.be.a.function
      o.name.should.equal 'test'

    it 'should contain event methods', ->
      o= new Cog name:'test'
      should.exist o.fire
      should.exist o.trigger
      should.exist o.emit
      should.exist o.on
      should.exist o.once
      should.exist o.off

      o.fire.should.be.a.function
      o.trigger.should.be.a.function
      o.emit.should.be.a.function
      o.on.should.be.a.function
      o.once.should.be.a.function
      o.off.should.be.a.function

    it 'should let you get properties directly or via get()', ->
      o= new Cog name:'test'
      should.exist o.name
      o.name.should.equal 'test'
      o.get('name').should.equal 'test'

    it 'should treat methods like attributes when using get()', ->
      o= new Cog name:'test'
      o.fullName= -> "Mr. #{@name}"
      o.get('name').should.equal 'test'
      o.get('fullName').should.equal 'Mr. test'

    it 'should return default value from get() if attribute is missing', ->
      o= new Cog name:'test'
      o.get('fullName', 'Mr. Mom').should.equal 'Mr. Mom'

    it 'should allow you to set values via set(name, value) or set(object)', ->
      o= new Cog
      o.set name:'test'
      should.exist o.name
      o.name.should.equal 'test'

      o.set 'name', 'new'
      o.name.should.equal 'new'

    it 'should trigger change:key events', ->
      o= new Cog name:'test'
      callbackCount= 0
      o.on 'change:name', (value, old)->
        value.should.equal 'new'
        old.should.equal 'test'
        callbackCount += 1
      o.set name:'new'
      callbackCount.should.equal 1

      # Manually changing a value should trigger no events
      o.name= 'test'
      o.name.should.equal 'test'
      callbackCount.should.equal 1

      o.set 'name', 'new'
      callbackCount.should.equal 2

    it 'should trigger `change` event with hash of changed attributes', (done)->
      o= new Cog name:'test'
      o.on 'change', (changes)->
        should.exist changes
        (typeof changes).should.equal 'object'
        changes.should.have.a.property 'name'
        changes.should.have.a.property 'other'
        done()
      o.set name:'updated', other:'new'

    it 'should provide access to previous values during event handler lifetime', ->
      o= new Cog name:'test'
      o.on 'change', (changes, model)->
        should.exist model
        changes.name.should.equal 'updated'
        model.previous('name').should.equal 'test'
      o.set name:'updated'

    it 'should provide method for checking changed keys', ->
      o= new Cog name:'test'
      o.on 'change', (changes, model)->
        model.hasChanged('name').should.be.true
        model.hasChanged('other').should.be.false
      o.set name:'updated'
      o.hasChanged('name').should.be.false

    it 'should provide hash of previous changes, but only since the last change', ->
      o= new Cog name:'test'
      o.on 'change', (changes, model)->
        should.exist model
        changes.name.should.equal 'updated'
        model.previous('name').should.equal 'test'
        # internal
        model._previous.name.should.equal 'test'
      o.set name:'updated'
      expect(o.previous('name')).to.be.null
      # internal
      o._previous.should.be.empty

