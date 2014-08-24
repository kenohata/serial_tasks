class ST.Views.PersonalView extends Backbone.View
  template: HandlebarsTemplates["personal"]

  render: ->
    @$el.append @template({})
    indexView = new ST.Views.TaskIndexView el: @$ '#tasks'
    newView = new ST.Views.NewTaskView el: @$ '#new-task'

    indexView.render()
    newView.render()
