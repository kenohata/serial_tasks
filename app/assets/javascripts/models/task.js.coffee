class ST.Models.Task extends Backbone.Model
  defaults:
    name: ""
    weight: 3
    selected: false

  urlRoot: ->
    "/tasks"

  toJSON: ->
    task:
      name: @get 'name'
      weight: @get 'weight'
