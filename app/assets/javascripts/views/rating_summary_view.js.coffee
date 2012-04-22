class app.RatingSummaryView extends app.BaseView
  className: 'rating-summary'
  template_id: 'album-summary-template'

  render: ->
    $(@el).html @template
      album: @model.get('album')
      user: @model.get('user')
      rating: @model.toJSON()
    @