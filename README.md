# About

ToasTunes is a lightweight [Sinatra](http://www.sinatrarb.com/)/[Rack](http://rack.rubyforge.org) app to browse and listen to your "iTunes Music" folder over the internet using an HTML5 browser. Native HTML5 audio means that Flash is not required. An optional script is included to export your iTunes album artwork to jpg/png for viewing in the browser (Mac OS X only).  ToasTunes should run under Ruby 1.8.7 or 1.9.2, and should work under Passenger on shared hosting such as Dreamhost.

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
* Tracks in an album playlist are not preloaded, so there is a slight pause between tracks. An implementation using two audio audio player instances will probably be necessary.
