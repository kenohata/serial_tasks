class ST.Views.TaskIndexView extends Backbone.View
  initialize: ->
    @tasks = db.tasks

    @listenTo @tasks, "add", (task) =>
      @addTask task

  addTask: (task) ->
    view = new ST.Views.TaskView task: task, tasks: @tasks
    view.render()
    @$el.append view.el
