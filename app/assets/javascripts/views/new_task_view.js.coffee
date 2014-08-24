class ST.Views.NewTaskView extends Backbone.View
  template: HandlebarsTemplates["new_task"]

  events:
    'keyup [name=name]' : 'onkeyup'
    'submit' : 'submit'

  $name: ->
    @$ 'input[name=name]'

  initialize: (options) ->
    @tasks = db.tasks
    @initializeTask()

  render: ->
    @$el.append @template {}

  initializeTask: ->
    @task = new ST.Models.Task

  onkeyup: (e) ->
    @task.set name: @$name().val()

  submit: (e) ->
    e.preventDefault()

    @task.save {},
      success: (task) =>
        @tasks.add task
        @initializeTask()
        @$name().val ""
