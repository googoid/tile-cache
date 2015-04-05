module.exports =
  cacheLifetime: 48 * 60 * 60
  port: 3005
  mongodb: 'mongodb://localhost:27017/tile-cache'
  tileServer:
    hostname: 'b.tiles.mapbox.com'
    path: '/v4/smarttaxi.c8c68db2/{zoom}/{x}/{y}{res}'
    scheme: 'http'
    resolution: '@2x.png'
    accessToken: 'pk.eyJ1IjoibWFwYm94IiwiYSI6IlhHVkZmaW8ifQ.hAMX5hSW-QnTeRCMAy9A8Q'
