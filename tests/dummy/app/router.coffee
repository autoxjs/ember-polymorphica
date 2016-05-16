`import Ember from 'ember'`
`import config from './config/environment'`
`import DSL from 'ember-polymorphica/utils/dsl'`
`import ModelConfluence from 'dummy/mixins/model-confluence'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  {namespace, collection, model, view, form, child, children} = DSL.import(@).with
    namespace: 
      routeMixins: ["namespace-xfire"]
    model: 
      routeMixins: [ModelConfluence]
    view: 
      routeMixins: ["cardboard:view-cardboard"]
    form: 
      routeMixins: ["mixin:form-cascade"]
    collection: 
      routeMixins: ["collection-paginate", "collection-serande"]

  namespace "dashboard", ->
    collection "projects", ->
      form "new"
      view "search"
      model "project", ->
        form "edit"

    collection "developments", ->
      form "new"

    namespace "admin", ->
      collection "users", ->
        model "user", ->
          form "edit"
          children "payments"

`export default Router`