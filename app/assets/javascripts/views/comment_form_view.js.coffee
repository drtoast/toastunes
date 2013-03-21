class app.CommentFormView extends app.BaseView
  className: 'comment-form'
  template_id: 'comment-form-template'

  events: ->
    'click button': 'submit'

  submit: (e) ->
    e.preventDefault()
    console.log 'submit'
    @model.save
      body: @$('.comment-text textarea[name="body"]').val()
    ,
      success: (model, response) =>
        @collection.add @model
        console.log 'success', response
      error: (model, response) =>
        console.log 'error', response

  render: ->
    $(@el).html @template
    @