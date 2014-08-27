class ST.Models.Task extends Backbone.Model
  defaults:
    name: ""
    weight: 3

  urlRoot: ->
    "/tasks"

  toJSON: ->
    task:
      name: @get 'name'
      weight: @get 'weight'
      sha1: @get 'sha1'
      task_state: @get 'task_state'
