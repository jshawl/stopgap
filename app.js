var express = require("express")
var app = express()
var mongoose = require("mongoose")
var resources = require("./resources")
mongoose.connect("mongodb://localhost/fake-rest-api")
var Project = require("./models/project")
app.set('view engine', 'hbs')

app.use(function(req, res, next){
  res.locals.url = 'http://localhost:3000'
  next()
})

app.get("/", function(req, res){
  res.render("index")
})

app.post("/", function(req, res){
  Project.create({},function(err,doc){
    res.redirect(doc._id)
  })
})

app.get("/:id", function(req, res){
  res.render("projects/show", {
    projectId: req.params.id
  })
})

app.get("/:projectId/:resource/:id", function(req, res){
  var data = resources[req.params.resource] || []
  res.render("resources/show", {
    projectId: req.params.id,
    resource: req.params.resource,
    data: JSON.stringify(data, null, 2),
    raw: data
  })
})
app.get("/:id/:resource.json", function(req, res){
  res.json(resources[req.params.resource] || [])
})
app.get("/:id/:resource", function(req, res){
  Project.findOne({_id:req.params.id}, function(err, project){
    res.render("resources/index", {
      projectId: req.params.id,
      resource: req.params.resource,
      data: JSON.stringify(project, null, 2),
      raw: project
    })
  })
})

app.listen(3000)