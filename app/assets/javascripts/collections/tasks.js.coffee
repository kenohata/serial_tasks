class ST.Collections.Tasks extends Backbone.Collection
  model: ST.Models.Task

  url: ->
    "/tasks"
