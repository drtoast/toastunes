# Handlebars Helpers

Handlebars.registerHelper 'length', (object) ->
  object.length

Handlebars.registerHelper 'thumbnail_path', (library, thumbnail) ->
    if thumbnail
      "/images/thumbnails/#{library}/#{thumbnail}"
    else
      "/images/thumbnail.png"

Handlebars.registerHelper 'cover_path', (library, cover) ->
    if cover
      "/images/covers/#{library}/#{cover}"
