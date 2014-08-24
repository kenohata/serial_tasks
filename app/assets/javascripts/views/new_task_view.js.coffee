class ST.Views.NewTaskView extends Backbone.View
  template: HandlebarsTemplates["new_task"]

  render: ->
    @$el.append @template {}
