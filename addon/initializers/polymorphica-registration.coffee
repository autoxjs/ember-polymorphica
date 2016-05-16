`import Ember from 'ember'`
`import {registerDefault, missingDefinition} from '../utils/registrar'`
`import getOwner from 'ember-getowner-polyfill'`

initialize = (application) ->
  container = if application.lookup? then application else application.__container__
  container
  .lookup "router:main"
  .one "willTransition", ->
    routeData = container.lookup "service:route-data"
    for routeName, opts of routeData.instance().routes
      registerDefault(application, "route", routeName, opts) if missingDefinition(application, "route", routeName)
      registerDefault(application, "controller", routeName, opts) if missingDefinition(application, "controller", routeName)

PolymorphicaRegistrationInitializer = 
  name: 'polymorphica-registration'
  initialize: initialize

`export {initialize}`
`export default PolymorphicaRegistrationInitializer`
