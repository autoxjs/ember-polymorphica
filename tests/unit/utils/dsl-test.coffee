`import { expect } from 'chai'`
`import { describe, it } from 'mocha'`
`import RouteData from 'ember-router-dsl/models/route-data'`
`import DSL from 'ember-polymorphica/utils/dsl'`

class FauxRouter
  @map = (f) ->
    router = new FauxRouter
    f.call router
  route: (name, opts, f) -> f?.call @

describe 'PolymorphicaDSL', ->
  after ->
    RouteData.reset()
  before ->
    FauxRouter.map ->
      {namespace, collection, children, model, child, form, view} = DSL.import(@).with
        namespace:
          routeMixins: ["namespace-feature"]
        collection:
          routeMixins: ["collection-feature"]
        model:
          routeMixins: ["model-feature"]
        form:
          routeMixins: ["terminal-feature"]

      namespace "dashboard", ->
        collection "projects", ->
          form "new"
          model "project", ->
            form "edit"
            children "histories"

          model "art-project", as: "project", ->
            form "edit"

        model "folder", ->
          children "image-files", as: "file"
  
  it 'should expose the RouteData construct', ->
    expect(RouteData?.instance()).to.be.an.instanceof RouteData
  
  it 'should have routes map', ->
    expect(RouteData.instance().routes).to.be.an.instanceof Object

  it 'form routeOptions', ->
    expect(RouteData.instance().routes["dashboard.projects.new"]).to.eql
      routeMixins: ["terminal-feature"]
      type: "form"
      model: "project"

  it 'collection routeOptions', ->
    expect(RouteData.instance().routes["dashboard.projects"]).to.eql
      routeMixins: ["collection-feature"]
      type: "collection"
      model: "project"

  describe 'RouteData.instance().routes["dashboard.projects.project"]', ->
    before ->
      @subject = RouteData.instance().routes["dashboard.projects.project"]

    it 'has keys', ->
      expect(@subject).to.have.all.keys ["routeMixins", "type", "model"]
    it "routeMixins", ->
      expect(@subject).to.have.deep.property("routeMixins[0]", "model-feature")
    it "type", ->
      expect(@subject).to.have.deep.property("type", "model")
    it "model", ->
      expect(@subject).to.have.deep.property("model", "project")
