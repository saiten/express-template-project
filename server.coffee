
express = require 'express'
routes = require './app/routes'

app = module.exports = express.createServer()

app.configure ->
  app.register '.html', require('eco')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session({secret: 'secret seed'})
  app.use app.router

  app.use express.compiler
    src: __dirname + '/app'
    dest: __dirname + '/public'
    enable: ['less', 'coffeescript']

  app.set 'views', __dirname + '/app/views'
  app.set 'view engine', 'html'
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler({dumpExceptions: true, showStack: true})

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', routes.index

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
