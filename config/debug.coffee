module.exports =
  cacheLifetime: 24 * 60 * 60
  port: 3005
  mongodb: 'mongodb://localhost:27000/tile-cache'
  tileServer:
    hostname: 'b.tiles.mapbox.com'
    path: '/v4/mapbox.streets/{zoom}/{x}/{y}{res}'
    scheme: 'http'
    resolution: '@2x.png'
    accessToken: 'pk.eyJ1IjoibWFwYm94IiwiYSI6IlhHVkZmaW8ifQ.hAMX5hSW-QnTeRCMAy9A8Q'
