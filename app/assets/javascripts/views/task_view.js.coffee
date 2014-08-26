class ST.Views.TaskView extends Backbone.View
  className: "task"
  template: HandlebarsTemplates["task"]

  events:
    'slide' : 'slide'
    'slidestop' : 'slidestop'
    'click .fa-play' : 'play'
    'click .fa-pause' : 'pause'
    'click .fa-check-square-o' : 'stop'
    'click .fa-times' : 'quit'
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

    @listenTo @task, 'change:task_state', =>
      @renderState()

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
    @renderAvatar()
    @renderState()

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

  renderAvatar: ->
    @$('#avatar').attr src: @task.get 'avatar_url'

  renderSelected: ->
    if @task.get 'selected'
      @enableSlider()
    else
      @disableSlider()

  renderState: ->
    @$('.state').addClass 'display-none'

    switch @task.get 'task_state'
      when 'todo'
        @$('.todo').removeClass 'display-none'
      when 'doing'
        @$('.doing').removeClass 'display-none'
      when 'pause'
        @$('.pause').removeClass 'display-none'
      when 'done'
        @$('.done').removeClass 'display-none'
      when 'quit'
        @$('.quit').removeClass 'display-none'

  renderClass: ->
    if @task.get 'selected'
      @$el.addClass 'active'
    else
      @$el.removeClass 'active'

  slidestop: (e, ui) ->
    @task.set weight: ui.value
    @save()

  slide: (e, ui) ->
    @task.set weight: ui.value

  play: ->
    @task.set task_state: 'doing'
    @save()

  pause: ->
    @task.set task_state: 'pause'
    @save()

  stop: ->
    @task.set task_state :'done'
    @save()

  quit: ->
    @task.set task_state :'quit'
    @save()

  click: ->
    selected = @tasks.findWhere selected: true
    selected.set selected: false if selected
    @task.set selected: true

  save: ->
    @task.save null,
      success: (model, response, options) =>
        model.set sha1: response.sha1

      error: (model, response, options) =>
        if response.responseJSON.hasOwnProperty 'sha1_changed?'
          if confirm "Conflict! gonna fetch the model."
            model.fetch()
