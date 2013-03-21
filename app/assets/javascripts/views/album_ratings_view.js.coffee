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
        user:
          name: app.user.get('name')
          email: app.user.get('email')
        album:
          _id: @model.get('_id')
          title: @model.get('title')
          artist_name: @model.get('artist_name')
          thumbnail: @model.get('thumbnail')
          library: @model.get('library')

  cache_ratings: ->
    @collection.each (rating) =>
      app.ratings.add rating

  render: ->
    console.log "AlbumRatingsView#render: #{@collection.length} ratings"
    @cache_ratings()
    console.log 'RATINGS', @collection.toJSON()
    $(@el).html @template
      ratings: @collection.toJSON()
    $(@el).find('.rating-form').html @form_view.render().el
    @