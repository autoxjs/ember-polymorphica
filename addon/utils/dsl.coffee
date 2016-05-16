`import DSL from 'ember-router-dsl/utils/dsl'`
`import _ from 'lodash/lodash'`

{partialRight, assign, noop, isFunction} = _

normalize = (defaults={}, args) ->
  [name, opts, f] = args
  switch args.length
    when 0 then throw new Error "You must pass in at least a name to declare a route"
    when 1 then [name, assign({}, defaults), noop]
    when 2
      if isFunction(opts)
        [name, defaults, opts]
      else
        [name, assign({}, defaults, opts), noop]
    else [name, assign({}, defaults, opts), f]
class PolymorphicaDSL
  baseDSL = null
  defaults = {}
  namespace: -> 
    baseDSL.namespace normalize(defaults.namespace, arguments)...
  collection: -> 
    baseDSL.collection normalize(defaults.collection, arguments)...
  children: -> 
    baseDSL.children normalize(defaults.children, arguments)...
  child: -> 
    baseDSL.child normalize(defaults.child, arguments)...
  model: -> 
    baseDSL.model normalize(defaults.model, arguments)...
  form: -> 
    baseDSL.form normalize(defaults.form, arguments)...
  view: -> 
    baseDSL.view normalize(defaults.view, arguments)...

  @import = (ctx) ->
    baseDSL = DSL.import(ctx)
    PolymorphicaDSL
  @with = (opts={}) ->
    defaults = opts
    new PolymorphicaDSL()

`export default PolymorphicaDSL`
