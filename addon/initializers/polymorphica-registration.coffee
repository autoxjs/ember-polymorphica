`import Ember from 'ember'`
`import {registerDefault, missingDefinition} from '../utils/registrar'`

### Router Extension Justification
We have to reopen the Ember Router to introduce a hook which fires after routing has begun
but before we handle our initial URL transition. This is because the initial transition has
the side-effect of lazily introducing route:basic which we don't want.

Consider the original source code at:
https://github.com/emberjs/ember.js/blob/v2.5.0/packages/ember-routing/lib/system/router.js#L162
###
{get} = Ember
initialize = (application) ->
  application.resolveRegistration("router:main").reopen
    startRouting: ->
      initialURL = get(@, 'initialURL')

      if @setupRouter()
        @trigger "startedRouting"
        if typeof initialURL is 'undefined'
          initialURL = get(@, 'location').getURL()
        initialTransition = @handleURL initialURL
        if initialTransition?.error
          throw initialTransition.error

PolymorphicaRegistrationInitializer = 
  name: 'polymorphica-registration'
  initialize: initialize

`export {initialize}`
`export default PolymorphicaRegistrationInitializer`
