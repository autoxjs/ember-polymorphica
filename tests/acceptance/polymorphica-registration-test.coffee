`import { describe, it, before, after } from 'mocha'`
`import { expect } from 'chai'`
`import startApp from '../helpers/start-app'`
`import destroyApp from '../helpers/destroy-app'`

describe 'Acceptance: PolymorphicaRegistration', ->
  application = null
  container = null
  before (done) -> 
    application = startApp()
    container = application.__container__
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

  describe 'route:dashboard', ->
    before ->
      @route = container.lookup "route:dashboard"

    it 'should have a routeName', ->
      expect(@route).to.have.property "routeName", "dashboard"

    it 'should not inherit the wrong mixin', ->
      expect(@route).to.not.have.property "paginate"

    it 'should have inherited the right mixin', ->
      expect(@route).to.have.property 'xfire', 'namespace'
  
  describe 'route:dashboard/projects', ->
    before ->
      @route = container.lookup 'route:dashboard/projects'

    it 'should have a routeName', ->
      expect(@route).to.have.property "routeName", "dashboard.projects"

    it 'should have inherited the right mixin', ->
      expect(@route).to.have.property "paginate", "collect"
  
  describe 'route:dashboard/projects/search', ->
    before ->
      @route = container.lookup "route:dashboard/projects/search"

    it 'should have a routeName', ->
      expect(@route).to.have.property "routeName", "dashboard.projects.search"

    it 'should inherit the right mixin', ->
      expect(@route).to.have.property "cardboard", "view"