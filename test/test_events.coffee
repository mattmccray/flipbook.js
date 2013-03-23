should= require('chai').should()
# this is the compiled output from assembot, 
# use it like you would the 'window' object:
events= require('../source/cog/events')

describe 'Cog', ->

  describe 'Events', ->
    
    beforeEach ->
      @obj= {}
      events.mixin @obj

    afterEach ->
      # delete @obj
      @obj= null

    it 'should exist', ->
      should.exist events

    it 'should contain the module loader', ->
      events.mixin.should.exist
      events.mixin.should.be.a.function

    it 'should mixin the methods', ->
      should.exist @obj.on
      should.exist @obj.addListener
      should.exist @obj.once
      should.exist @obj.off
      should.exist @obj.fire
      should.exist @obj.trigger
      should.exist @obj.emit

      @obj.on.should.be.a.function
      @obj.addListener.should.be.a.function
      @obj.once.should.be.a.function
      @obj.off.should.be.a.function
      @obj.fire.should.be.a.function
      @obj.trigger.should.be.a.function

      should.not.exist @obj._events

    it 'should allow listening to events', ()->
      testFired= 0
      @obj.on 'test',  ->
        testFired += 1
      should.exist @obj._events
      @obj.fire 'test'
      @obj.fire 'redHerring'
      testFired.should.be.equal 1
      @obj.fire 'test'
      testFired.should.be.equal 2


    it 'should allows listening to events only once', ->
      testFired= 0
      @obj.once 'test',  ->
        testFired += 1
      @obj.fire 'test'
      @obj.fire 'test'
      @obj.fire 'redHerring'
      @obj.fire 'test'
      testFired.should.be.equal 1

    it 'should allow unsubscribing to events', ->
      testFired= 0
      handler= ->
        testFired += 1
      
      @obj.on 'test', handler
      @obj.fire 'test'
      @obj.fire 'redHerring'
      @obj.off 'test', handler

      @obj.fire 'test'
      @obj.fire 'redHerring'
      @obj.fire 'test'
      testFired.should.be.equal 1

    describe 'listenTo()', ->

      beforeEach ->
        @other= {}
        events.mixin(@other)
      afterEach ->
        @other= null

      it 'should allow owning event listeners for better unsubscribing', ->
        testFired= 0
        handler= ->
          testFired += 1
        @other.listenTo @obj, 'test', handler

        @obj.fire 'test'
        @obj.fire 'redHerring'
        @obj.fire 'test'
        testFired.should.be.equal 2

        @other.stopListening @obj, 'test', handler

        @obj.fire 'test'
        @obj.fire 'test'
        testFired.should.be.equal 2
        @obj._events.should.be.empty

        should.not.exist @other._events
        should.exist @obj._events
        should.exist @other._emitterBindings
        @other._emitterBindings.should.be.empty

      it 'should unsubscribe all events from all target objects', ->
        testFired= 0
        obj2= {}
        obj3= {}
        events.mixin(obj2,obj3)
        handler= ->
          testFired += 1

        @other.listenTo @obj, 'test', handler
        @other.listenTo obj2, 'test', handler
        @other.listenTo obj3, 'test', handler

        @obj.fire 'test'
        obj2.fire 'test'
        obj3.fire 'test'
        
        testFired.should.be.equal 3

        @other.stopListening()

        @obj.fire 'test'
        obj2.fire 'test'
        obj3.fire 'test'
        testFired.should.be.equal 3
        
        @obj._events.should.be.empty
        obj2._events.should.be.empty
        obj3._events.should.be.empty

        @other._emitterBindings.should.be.empty

        @other.listenTo @obj, 'test', handler
        @other.listenTo obj2, 'test', handler
        @other.listenTo obj3, 'test', handler

        @obj.fire 'test'
        obj2.fire 'test'
        obj3.fire 'test'
        
        testFired.should.be.equal 6

        @other.stopListening(@obj)
        @other.stopListening(obj2)
        @other.stopListening(obj3)

        @obj.fire 'test'
        obj2.fire 'test'
        obj3.fire 'test'
        testFired.should.be.equal 6


      it 'should unsubscribe all events from target object', ->
        testFired= 0
        obj2= {}
        obj3= {}
        events.mixin(obj2,obj3)
        handler= ->
          testFired += 1

        @other.listenTo @obj, 'test', handler
        @other.listenTo obj2, 'test', handler
        @other.listenTo obj3, 'test', handler

        @obj.fire 'test'
        obj2.fire 'test'
        obj3.fire 'test'
        
        testFired.should.be.equal 3

        @other.stopListening(@obj)
        @other.stopListening(obj2, 'test')

        @obj.fire 'test'
        obj2.fire 'test'
        obj3.fire 'test'
        testFired.should.be.equal 4
        
        @obj._events.should.be.empty
        obj2._events.should.be.empty
        obj3._events.should.not.be.empty

        @other._emitterBindings.should.not.be.empty

        # console.log @obj
        # console.log other._emitterBindings
