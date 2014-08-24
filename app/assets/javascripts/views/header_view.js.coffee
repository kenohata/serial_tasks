class ST.Views.HeaderView extends Backbone.View
  template: HandlebarsTemplates["header"]

  render: ->
    @$el.append @template({})
