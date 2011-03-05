# About

<img width="800" src="http://drtoast.com/sc/toastunes_screenshot.png">

ToasTunes is a social web app for browsing and listening to a music library, adding comments and ratings, and adding album art and genre classifications. ToasTunes was written by @drtoast.

* Created using [Ruby 1.9](http://www.ruby-lang.org/), [Rails 3](http://rubyonrails.org/), [jQuery](http://jquery.com/), CSS3, HTML5
* [MongoDB](http://www.mongodb.org/) datastore via [Mongoid](http://mongoid.org)
* [HTML5 audio](http://diveintohtml5.org/) playback (no Flash required)
* [Devise](https://github.com/plataformatec/devise) for secure user authentication
* [HAML](http://haml-lang.com/) view templates
* [ID3](https://github.com/moumar/ruby-mp3info) tag parsing and album art extraction
* Album art retrieval using [Amazon AWS](http://aws.amazon.com/) API
* [Bundler](http://gembundler.com/) for dependency management

# Setup

## installation, Mac OSX:

    rvm install 1.9.2
    brew install mongodb
    brew install ghostscript
    brew install imagemagick
    git clone git://github.com/drtoast/toastunes.git
    cd toastunes
    bundle
    
## installation, BSD

    todo

## edit config files

edit config/toastunes.yml.sample, rename to toastunes.yml
edit config/mongoid.yml.sample, rename to toastunes.yml

To download album art via Amazon AWS, add your developer key id and secret key to config/toastunes.yml.

## add users

ToasTunes is meant for private use, so public user registration is disabled.  An admin can add a new user in the rails console:

    rails c
    u = User.new :email => 'you@something.com', :password => '123456'
    u.save!

## load an iTunes library

Create a symlink from your iTunes Music folder to public/music/itunes:

    cd toastunes/music
    ln -s ~/Music/iTunes/iTunes\ Music itunes

Edit the path to your iTunes library XML in config/toastunes.yml, then:

    rake toastunes:read:itunes
    
## load a directory

Make sure your library directory structure is the following:

    yourlibrary/Artist Name/Album Title/Song Title.mp3

Create a symlink from your music directory to public/music/yourlibrary:

    cd toastunes/music
    ln -s /volumes/yourlibrary yourlibrary

Run this rake task:

    rake toastunes:read:artists[yourlibrary]

# Bugs

Currently only runs well in Google Chrome.

Can't read filenames with funky characters on Samba shares, e.g. "Miss Kitten & The Hacker/Two/09 Inutile EternitÃ©.mp3"

Parsing of ID3 picture tags needs some work
