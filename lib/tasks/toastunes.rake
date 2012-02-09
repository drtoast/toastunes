namespace :toastunes do
  
  # rake RAILS_ENV=production toastunes:create:admin[name@example.com,somepass]
  namespace :create do
    task :admin, [:email, :password] => :environment do |t, args|
      u = User.find_or_create_by(:email => args.email.downcase)
      u.password = args.password
      u.admin    = true
      u.approved = true
      u.save
      p "created admin #{args.email} [#{u.id}]"
    end
  end
  
  namespace :read do
    
    # rake RAILS_ENV=production toastunes:read:artists[w2] --trace
    desc "load the given directory inside public/music, containing artist subdirectories"
    task :artists, [:library] => [:environment] do |t, args|
      args.with_defaults :library => 'w2'
      p = Toastunes::DirectoryParser.new(:library => args.library)
      p.parse!
    end
    
    # rake RAILS_ENV=production toastunes:read:artist[w2,Radiohead] --trace
    desc "load the given artist directory in public/music/[library]/[artist]"
    task :artist, [:dir, :artist] => [:environment] do |t, args|
      args.with_defaults :library => 'w2', :artist => 'Radiohead'
      p = Toastunes::DirectoryParser.new(:library => args.library)
      dir = File.join(Rails.root, 'public', 'music', args.library)
      p.parse_artist(dir, args.artist)
    end
    
    # rake RAILS_ENV=production toastunes:read:itunes["/Volumes/toastport/iTunes", toastport] --trace
    desc "load the iTunes XML library"
    task :itunes, [:path_to_itunes, :library_name] => :environment do |t, args|
      Toastunes::TunesParser.parse!(args.path_to_itunes, args.library_name)
    end
    
  end # namespace :read
  
  namespace :process do
    
    task :randomize => :environment do
      Album.all.each do |a|
        a.random_number = rand
        p [a.random_number, a.title].join("\t")
        a.save
      end
    end
    
    desc "process all album covers, artists, and genres"
    task :albums => :environment do
      Album.all.each do |a|
        begin
          a.extract_cover(true)
          a.set_artist
          a.set_genre
          a.save
        rescue => e
          p "WARNING: Couldn't process album #{a.id}: #{e.inspect}"
        end
        puts [a.title, a.artist ? a.artist.name : nil].join("\t")
      end
    end # task :albums
    
    desc "replace old genres with new ones loaded from an import file"
    task :replace_genres, [:file] => [:environment] do |t, args|
      File.open(args.file) do |f|
        f.each do |line|
          old_genre, new_genre = line.chomp.split(/\t/)
          Genre.swap(old_genre, new_genre)
        end
      end
    end
    
    desc "delete genres that have no albums"
    task :cleanup_genres => :environment do |t, args|
      Genre.cleanup
    end

    task :reset => :environment do |t, args|
      Album.destroy_all
      Artist.destroy_all
      Comment.destroy_all
      Genre.destroy_all
      Rating.destroy_all
    end
    
  end # namespace :process
  
end