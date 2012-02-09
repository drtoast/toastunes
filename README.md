# About

<img width="800" src="http://music.drtoast.com/files/images/sc/toastunes_screenshot.png">

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

Rename config/mongoid.yml.sample to toastunes.yml, and add your Mongo configuration.

Rename config/toastunes.yml.sample to toastunes.yml. To download album art via Amazon AWS, add your developer key id and secret key.

## add users

Add an initial admin user:

    rake toastunes:create:admin[you@example.com,somepassword]

To add users, send them to /users/sign_up, then log in as an admin to approve their account at /users.

## load an iTunes library

To load your iTunes library, run the following rake task, providing a path to your iTunes folder, and an optional name for the library (when managing multiple libraries).

    rake toastunes:read:itunes['/path/to/iTunes',itunes]

Then extract/process album art, artists, genres:

    rake toastunes:process:albums

## load a directory

Make sure your library directory structure is like the following:

    yourlibrary/Artist Name/Album Title/Song Title.mp3

Create a symlink from your music directory to public/music/yourlibrary:

    cd toastunes
    ln -s /volumes/yourlibrary public/music/yourlibrary

Parse your library

    rake toastunes:read:artists[yourlibrary]

## Utilities

replace old genres with new ones via a lookup file

    rake toastunes:process:replace_genres[/path/to/lookup.tab]

delete genres that have no albums

    rake toastunes:genres:cleanup

delete everything(!)

    rake toastunes:process:reset

## Deploy

precompile assets prior to a production release (public/assets currently ignored in .gitignore)

    rake assets:precompile

# Bugs

Currently only runs well in Google Chrome.

Can't read filenames with funky characters on Samba shares, e.g. "Miss Kitten & The Hacker/Two/09 Inutile EternitÃ©.mp3"

Parsing of ID3 picture tags needs some work
