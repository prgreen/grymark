express = require "express"
routes  = require "./routes"
http    = require "http"
path    = require "path"

# CONFIGURATION
app = express()

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon(__dirname + '/public/images/pong.ico', { maxAge: 2592000000 })
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use require("stylus").middleware(__dirname + "/public")
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

redis = require "redis"
db = redis.createClient()

# URLS
app.get "/", routes.index
app.get "/download", routes.download
app.get "/register", routes.register
app.get "/donate", routes.donate
app.get "/thanks", routes.donate
app.get "/about", routes.about
#app.get "/googlebcb358032381cfe6.html", routes.google

app.post "/register", routes.register_post(db)
app.get "/hiscore/:id", routes.hiscore(db)
app.post "/hiscore", routes.hiscore_post(db)

# RUN SERVER
server = http.createServer(app)

server.listen app.get("port"), ->
  console.log ("Express server listening on port " + app.get("port"))


