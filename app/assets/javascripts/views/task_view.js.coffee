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

    @renderName()
    @renderWeight()

    @$('#weight-slider').slider
      value: @task.get 'weight'
      min: 3,
      max: 12,
      step: 1

    @renderSelected()

  enableSlider: ->
    @$('#weight-slider').slider "enable"

  disableSlider: ->
    @$('#weight-slider').slider "disable"

  renderName: ->
    @$('#name').html @task.get 'name'

  renderWeight: ->
    @$('#weight').html @task.get 'weight'

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
    @task.save null

  slide: (e, ui) ->
    @task.set weight: ui.value

  click: ->
    selected = @tasks.findWhere selected: true
    selected.set selected: false if selected
    @task.set selected: true
