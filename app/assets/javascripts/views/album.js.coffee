tt.Views.Album = Backbone.View.extend

  el: '#stage'

  template: ->
    h1 "hello album"

  render: ->
    $(@el).html(CoffeeKup.render(@template))
    @

