`import Ember from 'ember'`
`import {registerDefault, missingDefinition} from '../utils/registrar'`

initialize = (instance) ->
  instance.lookup "router:main"
  .one "startedRouting", ->
    routeData = instance.lookup "service:route-data"
    for routeName, opts of routeData.instance().routes 
      registerDefault(instance, "route", routeName, opts) if missingDefinition(instance, "route", routeName)
      registerDefault(instance, "controller", routeName, opts) if missingDefinition(instance, "controller", routeName)

PolymorphicaCoreRegistrationInitializer = 
  name: 'polymorphica-core-registration'
  initialize: initialize

`export {initialize}`
`export default PolymorphicaCoreRegistrationInitializer`
