`import Ember from 'ember'`
`import getOwner from 'ember-getowner-polyfill'`
{String: {capitalize}, isPresent, isBlank, typeOf, getWithDefault, A} = Ember

MixinRegex = /^\w+:/

assertPresence = (reference, obj) ->
  return obj if isPresent obj
  throw new Error "Expected to find a mixin named '#{reference}', instead I got this horseshit '#{obj}'"

toMixins = (app, type, opts) ->
  getWithDefault(opts, "#{type}Mixins", A [])
  .map (mixin) ->
    assertPresence mixin, switch
      when typeOf(mixin) is "string" and mixin.match(MixinRegex)
        app.resolveRegistration mixin
      when typeOf(mixin) is "string"
        app.resolveRegistration "mixin:#{mixin}"
      else mixin

normalizeName = (type, name) ->
  [type, name.split(".").join("/")].join ":"

registerDefault = (app, type, name, opts) ->
  mixins = toMixins(app, type, opts)
  return if isBlank mixins
  app.register normalizeName(type, name), Ember[capitalize type].extend mixins..., {}

missingDefinition = (application, type, name) ->
  not application.hasRegistration normalizeName(type, name)

`export {missingDefinition, registerDefault, toMixins, normalizeName}`