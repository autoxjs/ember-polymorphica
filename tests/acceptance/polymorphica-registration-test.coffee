`import { describe, it, beforeEach, afterEach, before, after } from 'mocha'`
`import { expect } from 'chai'`
`import startApp from '../helpers/start-app'`
`import destroyApp from '../helpers/destroy-app'`
`import getOwner from 'ember-getowner-polyfill'`

describe 'Acceptance: PolymorphicaRegistration', ->
  application = null
  owner = null
  container = null
  before (done) -> 
    application = startApp()
    container = application.__container__
    owner = getOwner application
    visit "/"
    andThen -> done()

  after -> 
    destroyApp application

  it 'should render', ->
    expect currentPath()
    .to.equal "index"

  it 'should find the application route', ->
    expect container.lookup "route:application"
    .to.be.ok

  it 'should find the dashboard route', ->
    expect container.lookup "route:dashboard"
    .to.be.ok

  it 'route:dashboard', ->
    route = container.lookup "route:dashboard"
    expect route.get "paginate"
    .to.not.be.ok
    expect route.get "xfire"
    .to.equal "namespace"

  it 'route:dashboard/projects', ->
    route = container.lookup "route:dashboard/projects"
    expect route.get "paginate"
    .to.equal "collect"
  
  it 'route:dashboard/projects/search', ->
    route = container.lookup "route:dashboard/projects/search"
    expect route.get "cardboard"
    .to.equal "view"
    