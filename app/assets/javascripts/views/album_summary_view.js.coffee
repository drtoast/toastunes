class app.AlbumSummaryView extends app.BaseView
  className: 'album-summary'
  template_id: 'album-summary-template'

  render: ->
    $(@el).html @template
      album: @model.toJSON()
    @