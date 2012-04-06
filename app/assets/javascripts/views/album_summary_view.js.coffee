class app.AlbumSummaryView extends app.BaseView
  className: 'album-summary'
  template_id: 'album-summary-template'

  events: ->
    'click': 'select_album'

  select_album: ->
    view = new app.AlbumDetailView model:@model
    $('#album-detail').html view.render().el
