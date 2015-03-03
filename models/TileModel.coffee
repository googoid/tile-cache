mongoose = require 'mongoose'
config = require '../config'

TileSchema = new mongoose.Schema
  x: Number
  y: Number
  zoom: Number
  imageData: Buffer
  createdAt:
    type: Date
    default: Date.now
    expires: config.cacheLifetime

Tile = module.exports = mongoose.model 'Tile', TileSchema
Tile.ensureIndexes {x: 1, y: 1, zoom: 1}, {unique: true}