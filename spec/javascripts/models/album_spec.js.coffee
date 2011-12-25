describe "Album", ->
  beforeEach ->
    @album = new tt.Models.Album

  it "has a foo attribute", ->
    expect(@album.foo).toEqual('bar')
