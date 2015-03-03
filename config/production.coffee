module.exports =
  cacheLifetime: 24 * 60 * 60
  port: 3005
  mongodb: 'mongodb://localhost:27017/tile-cache'
  lyrkServer:
    hostname: 'tiles.lyrk.org'
    scheme: 'http'
    resolution: 'lr'
