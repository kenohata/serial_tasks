class ST.Models.Task extends Backbone.Model
  urlRoot: ->
    "/tasks"

  toJSON: ->
    task:
      name: @get 'name'
