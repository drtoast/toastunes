class app.BaseView extends Backbone.View

  initialize: ->
    @template = Handlebars.compile $("##{@template_id}").html()

  render: ->
    $(@el).html @template(@model.toJSON())
    @