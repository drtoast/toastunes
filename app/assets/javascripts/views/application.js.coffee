tt.Views.Application = Backbone.View.extend
  el: '#stage'

  render: ->
    $(@el).html('hello')
