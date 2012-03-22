describe "Album", ->
  beforeEach ->
    @album = new Models.Album(artist:"somebody")

  it "should have an artist", ->
    expect(@album.get('artist')).toEqual("somebody")
