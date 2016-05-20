`import Ember from 'ember'`
`import getOwner from 'ember-getowner-polyfill'`
{String: {capitalize}, isPresent, isBlank, typeOf, getWithDefault, A} = Ember

MixinRegex = /^\w+:/

assertPresence = (reference, obj) ->
  return obj if isPresent obj
  throw new Error "Expected to find a mixin named '#{reference}', instead I got this horseshit '#{obj}'"

toMixins = (instance, type, opts) ->
  getWithDefault(opts, "#{type}Mixins", A [])
  .map (mixin) ->
    assertPresence mixin, switch
      when typeOf(mixin) is "string" and mixin.match(MixinRegex)
        instance.resolveRegistration mixin
      when typeOf(mixin) is "string"
        instance.resolveRegistration "mixin:#{mixin}"
      else mixin

normalizeName = (type, name) ->
  [type, name.split(".").join("/")].join ":"

registerDefault = (instance, type, name, opts) ->
  Factory = Ember[capitalize type]
  registerClass Factory, instance, type, name, opts

registerClass = (Factory, instance, type, name, opts) ->
  mixins = toMixins(instance, type, opts)
  return if isBlank mixins
  fullname = normalizeName(type, name)
  instance.register fullname, Factory.extend mixins..., {}
  instance.lookup(fullname)["#{type}Name"] = name


missingDefinition = (application, type, name) ->
  not application.hasRegistration normalizeName(type, name)

`export {missingDefinition, registerDefault, registerClass, toMixins, normalizeName}`