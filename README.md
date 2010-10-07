# About

ToasTunes is a lightweight [Sinatra](http://www.sinatrarb.com/)/[Rack](http://rack.rubyforge.org) app to browse and listen to your "iTunes Music" folder over the internet using an HTML5 browser. The [jPlayer](http://www.happyworm.com/jquery/jplayer/) JavaScript library and native HTML5 audio mean that Flash is not required. An optional script is included to export your iTunes album artwork to jpg/png for viewing in the browser (Mac OS X only).  Toastunes should run under Ruby 1.8.7 or 1.9.2, and should work under Passenger on shared hosting such as Dreamhost.

# Setup

Rename config.sample.yml to config.yml, and specify the full paths to your "music" and "views" directories.

Then:

    rvm 1.9.2 (optional)
    cd toastunes
    bundle install
    cd public; ln -s '/users/yourname/Music/iTunes/iTunes Music' music;
    rake export_artwork (optional)

# Run

If you're running in passenger, touch tmp/restart.txt.  Or to run locally on port 9292:

    rackup config.ru

# Listen and Enjoy

http://yourhost.com:9292

# Bugs

* Artists, albums, and songs containing an ampersand (&) or plus sign (+) don't work
* Tracks in an album playlist are not preloaded, so there is a slight pause between tracks. An implementation using [two jPlayer instances](http://groups.google.com/group/jplayer/browse_thread/thread/bb65740673c1e599) will probably be necessary.
