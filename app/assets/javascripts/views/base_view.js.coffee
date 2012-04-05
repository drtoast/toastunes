class app.BaseView extends Backbone.View

  initialize: ->
    @template = $("##{@template_id}").html()

  render: ->
    $(@el).html Mustache.render(@template, @model.toJSON())
    @