# Ember-polymorphica

Ember mixin and registration service for creating polymorphic routes.

## Example
Usage with special DSL in your `router.coffee`

```coffeescript
`import SomeRouteMixin from '../mixins/some-route-mixin'`
`import SomeControllerMixin from '../mixins/some-controller-mixin'`

Router.map ->
  {namespace, collection, children, model, child, form, view} = DSL.import(@).with
    namespace:
      routeMixins: ["namespace-feature"]
      controllerMixins: ["namespace-controller"]
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
```
Now, the dashboard route and all its children will have the SomeRouteMixin mixed in.

## Dependencies
the following packages should be installed prior to use:

```sh
ember-router-dsl
ember-lodash
ember-inflector
```

## Installation

* `git clone` this repository
* `npm install`
* `bower install`

## Running

* `ember server`
* Visit your app at http://localhost:4200.

## Running Tests

* `npm test` (Runs `ember try:testall` to test your addon against multiple Ember versions)
* `ember test`
* `ember test --server`

## Building

* `ember build`

For more information on using ember-cli, visit [http://ember-cli.com/](http://ember-cli.com/).
