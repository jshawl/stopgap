var mongoose = require("mongoose")
var resources = require("../resources")
var ResourceSchema = new mongoose.Schema({ })
var Resource = mongoose.model('Resource',ResourceSchema)
module.exports = Resource
