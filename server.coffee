http = require 'http'
mongoose = require 'mongoose'
config = require './config'
Promise = require 'promise'
Tile = require './models/TileModel'
debug = require('debug') 'tile-cache'
url = require 'url'
_ = require 'underscore'
Stream = require 'stream'
ReadableStream = Stream.Readable

server = http.createServer (req, res) ->
  handleRequest req, res
mongoose.connection.on 'open', () ->
  debug 'Successfully connected to mongodb at ' + config.mongodb
  server.listen config.port, () ->
    debug 'Listening on *:' + config.port + '...'

mongoose.connect config.mongodb


handleRequest = (req, res) ->
  _url = url.parse req.url
  parts = _url.pathname.split '/'
  if parts[1] is 'favicon.ico'
    res.writeHead 404, 'Content-Type': 'text/plain'
    res.end ''
    return
  if parts.length isnt 4
    res.writeHead 500, 'Content-Type': 'application/json'
    res.end JSON.stringify new Error 'URL must be /{zoom}/{x}/{y}'
    return
  [zoom, x, y] = parts.slice 1
  fetchTileData x, y, zoom
  .then (buffer) ->
    debug [x, y, zoom].join ', '
    res.writeHead 200, 'Content-Type': 'image/jpeg'
    res.end buffer
  .then null, (err) ->
    debug err
    res.writeHead 500, 'Content-Type': 'application/json'
    res.end err.message
  

fetchTileData = (x, y, zoom) ->
  new Promise (resolve, reject) ->
    Tile.findOne {x: x, y: y, zoom: zoom}
    .exec()
    .then (tile) ->
      if tile?
        resolve tile.imageData
      else
        downloadTileData x, y, zoom
        .then (buffer) ->
          tile = new Tile
            x: x
            y: y
            zoom: zoom
            imageData: buffer
          tile.save()
          resolve buffer
        .then null, (err) ->
          reject err
          
    .then null, (err) ->
      reject err
  
downloadTileData = (x, y, zoom) ->
  debug "download #{zoom}/#{x}/#{y}"
  new Promise (resolve, reject) ->
    pathname = config.tileServer.path
    pathname = pathname.replace '{zoom}', zoom
    pathname = pathname.replace '{x}', x
    pathname = pathname.replace '{y}', y
    pathname = pathname.replace '{res}', config.tileServer.resolution
    pathname += '?access_token=' + config.tileServer.accessToken
    
    options =
      hostname: config.tileServer.hostname
      method: 'GET'
      path: pathname
      #headers:
    req = http.request options
    req.on 'response', (res) ->
      if res.statusCode isnt 200
        reject new Error "Unable to download tile from #{pathname}"
        return
        
      buffer = null
      res.on 'data', (data) ->
        if not buffer
          buffer = data
        else
          buffer = Buffer.concat [buffer, data]
      res.on 'end', () ->
        resolve buffer
    req.on 'error', (err) ->
      reject err
    req.end()
