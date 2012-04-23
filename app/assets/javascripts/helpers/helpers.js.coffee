# Handlebars Helpers

Handlebars.registerHelper 'length', (object) ->
  object.length

Handlebars.registerHelper 'thumbnail_path', (library, thumbnail) ->
    if thumbnail
      "/images/thumbnails/#{library}/#{thumbnail}"
    else
      "/assets/thumbnail.png"

Handlebars.registerHelper 'cover_path', (library, cover) ->
    if cover
      "/images/covers/#{library}/#{cover}"

Handlebars.registerHelper 'render_stars', (rating) ->
    count = rating / 20
    stars = []
    if rating >= 20
      stars.push '<div class="star bright"></div>' for i in [1..count]
    else
      stars.push '<div class="star"></div>'
    stars.join('')