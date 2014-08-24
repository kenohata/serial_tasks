class ST.Views.PersonalView extends Backbone.View
  template: HandlebarsTemplates["personal"]

  render: ->
    @$el.append @template({})
    newView = new ST.Views.NewTaskView el: @$('#new-task')
    newView.render()
