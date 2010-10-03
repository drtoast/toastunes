# About

ToasTunes is a lightweight [Sinatra](http://www.sinatrarb.com/) app to browse and listen to your home "iTunes Music" folder over the internet using an HTML5 browser. The [jPlayer](http://www.happyworm.com/jquery/jplayer/) JavaScript library and native HTML5 audio mean that Flash is not required. An optional script is included to export your iTunes album artwork to jpg/png for viewing in the browser (Mac OS X only).  The app was built and tested with Ruby 1.9.2 - use [rvm](http://rvm.beginrescueend.com/) if your Ruby is older.

# Setup

Create a config.yml to change the default port number of 4567:

    port:
        9876

Then:

    rvm 1.9.2 (optional)
    cd toastunes
    bundle install
    cd public; ln -s '/users/yourname/Music/iTunes/iTunes Music' music;
    rake export_artwork (optional)

# Run

    ruby toastunes.rb -e production

# Listen and Enjoy

http://yourhost.com:5550

# Bugs

* Artists, albums, and songs containing an ampersand (&) don't work
* Tracks in an album playlist are not preloaded, so there is a pause between tracks. An implementation using [two jPlayer instances](http://groups.google.com/group/jplayer/browse_thread/thread/bb65740673c1e599) will probably be necessary.