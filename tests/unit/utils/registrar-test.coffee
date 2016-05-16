`import Ember from 'ember'`
`import { expect } from 'chai'`
`import { describe, it } from 'mocha'`
`import { registerDefault, missingDefinition, toMixins } from 'ember-polymorphica/utils/registrar'`

{setOwner} = Ember.__loader.require('container/owner')
{Mixin, isPresent} = Ember
class FauxApplication
  constructor: (@registry = {}) ->
  hasRegistration: (name) ->
    isPresent @lookup name
  resolveRegistration: (name) -> @lookup name
  lookup: (name) ->
    @registry[name]
  register: (name, something) ->
    @registry[name] = something
  clear: ->
    @registry = {}

describe 'Registrar', ->
  before -> 
    @app = new FauxApplication()
    setOwner @app, @app
  describe 'missingDefinition', ->
    before -> @app.register "route:something", {}
    after -> @app.clear()

    it "should have registered stuff", ->
      expect missingDefinition(@app, "route", "something")
      .to.be.false

    it "should not have missing stuff", ->
      expect missingDefinition(@app, "controller", "missing")
      .to.be.true

  describe "toMixins", ->
    before ->
      @app.register "mixin:applesauce", name: "applesauce"
      @app.register "mixout:cranberry", name: "cranberry"
      @routeMixins = ["applesauce", "mixout:cranberry", {name: "raw"}]
      @subject = toMixins @app, "route", {@routeMixins}
    after -> @app.clear()

    it "should properly convert applesauce", ->
      expect @subject
      .to.have.deep.property "[0].name", "applesauce"

    it "should properly convert cranberry", ->
      expect @subject
      .to.have.deep.property "[1].name", "cranberry"

    it "should properly convert raw", ->
      expect @subject
      .to.have.deep.property "[2].name", "raw"

  describe "registerDefault", ->
    before ->
      @app.register "mixin:applesauce", Mixin.create name: "applesauce"
      @app.register "mixout:cranberry", Mixin.create place: "cranberry"
      @routeMixins = ["applesauce", "mixout:cranberry", Mixin.create(style: "raw")]
      registerDefault(@app, "route", "dashboard.projects.new", {@routeMixins})
      @factory = @app.lookup "route:dashboard/projects/new"
      @instance = @factory.create()
    after -> @app.clear()

    it "should find the factory", ->
      expect @factory
      .to.be.ok

    it "should find the instance", ->
      expect @instance
      .to.be.ok

    it "should match name", ->
      expect @instance
      .to.have.deep.property "name", "applesauce"

    it "should match place", ->
      expect @instance
      .to.have.deep.property "place", "cranberry"

    it "should match style", ->
      expect @instance
      .to.have.deep.property "style", "raw"