tt.Models.Album = Backbone.Model.extend
  foo: 'bar'

tt.Collections.Albums = Backbone.Collection.extend
  model: tt.Models.Album
  url: "/albums"

tt.Collections.Playlist = tt.Collections.Albums.extend
