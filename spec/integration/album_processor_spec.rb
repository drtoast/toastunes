require 'spec_helper'
require 'fileutils'

describe Toastunes::AlbumProcessor do

  let(:album_temp_path) { File.join('/tmp', 'toastunes-test') }

  before do
    FileUtils.rm_rf album_temp_path
  end

  context 'when given an artist name and album title' do

    before do
      opts = {
        url: 'foo',
        artist_name: 'Artist A',
        album_title: 'Album A',
        library: 'test',
      }
      @processor = Toastunes::AlbumProcessor.new(opts)
      @processor.stub(:download_zip)
      @processor.zip_file = File.join(Rails.root, 'spec', 'fixtures', 'Artist A - Album A.zip')
      @processor.album_path = album_temp_path
    end

    it 'processes a zip file of MP3s' do
      @processor.process!

      # Album
      album = Album.where(title: 'Album A').first
      album.artist_name.should eq('Artist A')
      album.library.should eq('test')
      album.compilation.should be_false

      # Artist
      artist = album.artist
      artist.name.should eq('Artist A')

      # track A
      track = album.tracks.first
      track.title.should eq('Track A')
      track.kind.should eq('mp3')
      track.artist_name.should eq('Artist A')
      track.track.should eq(1)
      track.location.should match(/\/public\/music\/test\/Artist A\/Album A\/01 Track A\.mp3$/)

      # track B
      track = album.tracks.last
      track.title.should eq('Track B')
      track.kind.should eq('mp3')
      track.artist_name.should eq('Artist A')
      track.track.should eq(2)
      track.location.should match(/\/public\/music\/test\/Artist A\/Album A\/02 Track B\.mp3$/)

    end
  end

end
