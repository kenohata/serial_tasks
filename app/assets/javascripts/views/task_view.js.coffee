class ST.Views.TaskView extends Backbone.View
  className: "task"
  template: HandlebarsTemplates["task"]

  events:
    'slide' : 'slide'
    'slidestop' : 'slidestop'
    'click' : 'click'

  initialize: (options) ->
    @task = options.task
    @tasks = options.tasks

    @listenTo @task, 'change:name', =>
      @renderName()

    @listenTo @task, 'change:weight', =>
      @renderWeight()

    @listenTo @task, 'change:selected', (task) =>
      @renderSelected()
      @renderClass()

  render: ->
    @$el.html @template()

    @$slider = @$('#weight-slider').slider
      value: @task.get 'weight'
      min: 3,
      max: 12,
      step: 1

    @renderName()
    @renderWeight()
    @renderSelected()

  enableSlider: ->
    @$slider.slider "enable"

  disableSlider: ->
    @$slider.slider "disable"

  renderName: ->
    @$('#name').html @task.get 'name'

  renderWeight: ->
    weight = @task.get 'weight'
    @$('#weight').html weight
    @$slider.slider "value", weight

  renderSelected: ->
    if @task.get 'selected'
      @enableSlider()
    else
      @disableSlider()

  renderClass: ->
    if @task.get 'selected'
      @$el.addClass 'active'
    else
      @$el.removeClass 'active'

  slidestop: (e, ui) ->
    @task.set weight: ui.value
    @task.save null,
      success: (model, response, options) =>
        model.set sha1: response.sha1

      error: (model, response, options) =>
        if response.responseJSON.hasOwnProperty 'sha1_changed?'
          if confirm "Conflict! gonna fetch the model."
            model.fetch()

  slide: (e, ui) ->
    @task.set weight: ui.value

  click: ->
    selected = @tasks.findWhere selected: true
    selected.set selected: false if selected
    @task.set selected: true
