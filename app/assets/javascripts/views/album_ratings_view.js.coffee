class app.AlbumRatingsView extends app.BaseView
  className: 'album-ratings'
  template_id: 'album-ratings-template'

  initialize: ->
    super
    @collection = new app.Ratings(@model.ratings())
    @collection.bind 'add', @render, @
    @collection.bind 'reset', @render, @
    @collection.fetch
      add: true
      data:
        album_id: @model.get('_id')
    @form_view = new app.RatingFormView
      collection: @collection
      model: new app.Rating
        album_id: @model.id

  cache_ratings: ->
    @collection.each (rating) =>
      app.ratings.add rating

  render: ->
    console.log "AlbumRatingsView#render: #{@collection.length} ratingss"
    @cache_ratings()
    $(@el).html @template
      ratings: @collection.toJSON()
    $(@el).find('.rating-form').html @form_view.render().el
    @