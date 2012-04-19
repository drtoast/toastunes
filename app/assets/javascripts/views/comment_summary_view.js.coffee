class app.CommentSummaryView extends app.BaseView
  className: 'album-summary'
  template_id: 'album-summary-template'

  render: ->
    $(@el).html @template
      album: @model.get('album')
      comment: @model.toJSON()
    @