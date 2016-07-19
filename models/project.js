var mongoose = require("mongoose")
var resources = require("../resources")
var ProjectSchema = new mongoose.Schema({
})
ProjectSchema.plugin(require('mongoose-lifecycle'));



var Project = mongoose.model('Project',ProjectSchema)

module.exports = Project
