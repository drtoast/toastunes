class app.RatingFormView extends app.BaseView
  className: 'rating-form'
  template_id: 'rating-form-template'

  events: ->
    'click button': 'submit'
    'mouseover .star': 'add_glow'
    'mouseout .star': 'remove_glow'
    'click .star': 'select_rating'

  add_glow: (e) ->
    $(e.target).prevAll().andSelf().addClass('glow');

  remove_glow: (e) ->
    $(e.target).siblings().andSelf().removeClass('glow');

  select_rating: (e) ->
    $(e.target).siblings().removeClass("bright");
    $(e.target).prevAll().andSelf().addClass("bright");

  submit: (e) ->
    e.preventDefault()
    @model.save
      rating: @$('something').val()
    ,
      success: (model, response) =>
        @model.save(model)
        @collection.add @model
        console.log 'success', response
      error: (model, response) =>
        console.log 'error', response

  render: ->
    $(@el).html @template
    @