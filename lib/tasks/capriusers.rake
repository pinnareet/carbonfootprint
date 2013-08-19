namespace :capriuser do

  #desc 'Put Capri user data from csv file into table'
  #task :populate => :environment do
  #  require 'csv'
  #  CSV.foreach('public/data/capri_residence.csv', :headers => true) do |row|
  #    Capri.create!(row.to_hash)
  #  end
  #end

  desc 'Put data from csv file into table'
  task :populate,[:filename,:model] => :environment do |task, args|
    require 'csv'
    CSV.foreach('public/data/' + args.filename, :headers => true) do |row|
      eval (args.model + '.create!(row.to_hash)')
    end
  end

  desc 'Find distance for capri users'
  task :distance => :environment do
    Capri.all.each do |user|
      if user.distance == nil then
        if user.geocoded? then
          user.update_attribute :distance, user.distance_to('Stanford University')
          #already stored as integer
        end
      end
    end
  end

  desc 'Put month into Commuters'
  task :get_month => :environment do
    Commuter.all.each do |commute|
      commute.update_attribute :month, commute.scan_time[0,7]
    end
  end

  desc 'Parse date into Commuters'
  task :parse_date,[:model,:date_col,:str_col] => :environment do |task, args|
    eval (args.model + '.all.each do |item|
      if item.' + args.str_col + '!= "NULL" then
      item.update_attribute :' + args.date_col+ ', DateTime.strptime(item.' + args.str_col + ", '%Y-%m-%d %H:%M:%S')
    end end")
  end

  desc 'Delete data'
  task :delete, [:model] => :environment do |task, args|
    eval (args.model + '.destroy_all;' +
    args.model + '.reset_pk_sequence')
  end

  desc 'Find missing id'
  task :missing_id => :environment do
    missing = Array.new()
    for i in 1..2283
      if Capri.find_by_user_id(i) == nil then
        missing << i
      end
    end
    File.open('public/data/deleted.txt', 'w') { |file| file.write(missing) }
    #id in deleted.txt is Capri.id not user id.
  end

  desc 'Initialize entrance table'
  task :init_entrance => :environment do
    Entrance.create(:latitude => 37.422486, :longitude => -122.182062)
    Entrance.create(:latitude => 37.431244, :longitude => -122.185302)
    Entrance.create(:latitude => 37.433016, :longitude => -122.179830)
    Entrance.create(:latitude => 37.434959, :longitude => -122.173092)
    Entrance.create(:latitude => 37.437378, :longitude => -122.166913)
    Entrance.create(:latitude => 37.436833, :longitude => -122.165840)
    Entrance.create(:latitude => 37.435197, :longitude => -122.163265)
    Entrance.create(:latitude => 37.429643, :longitude => -122.152536)
    a_entrance = Entrance.new do |p|
      p.id = 13
      p.latitude = 37.419555
      p.longitude = -122.157342
      p.save
    end
    b_entrance = Entrance.new do |p|
      p.id = 16
      p.latitude = 37.419214
      p.longitude = -122.175238
      p.save
    end
    #9 is 13 in the commuters and 10 is 16 in the commuters
  end

  desc 'Calculate commute distance'
  task :calc_distance => :environment do
    #a = Array.new()
    #f = File.open('public/data/deleted.txt')
    #f.each_line {|line|
    #  a = eval(line)
    #}
    #f.close
    Commuter.all.each do |commute|
      #if commute.distance == nil then
      if commute.user_id < 2554 then
        c_user = User.find(commute.user_id)
        if c_user!= nil then
          user = Capri.find_by_full_name(c_user.full_name)
          if user != nil and user.geocoded? then
            commute.update_attribute :distance, user.distance_to(Entrance.find(commute.location).coordinates)
            #already stored as integer
          end
        end
      end
      #end
    end
  end

  desc 'Remove commutes with invalid user'
  task :rm_commutes => :environment do
    a = Array.new()
    f = File.open('public/data/deleted.txt')
    f.each_line {|line|
      a = eval(line)
    }
    f.close
    Commuter.all.each do |commute|
      if a.include? Capri.find_by_user_id(commute.user_id).id then
        commute.destroy
      end
    end
  end

  desc 'Check if any commute distance is nil'
  task :check_dist_nil => :environment do
    a = Array.new()
    f = File.open('public/data/deleted.txt')
    f.each_line {|line|
      a = eval(line)
    }
    f.close
    Commuter.all.each do |commuter|
      if commuter.distance == nil then
        if commuter.user_id < 2554 then
          commute_user = User.find(commuter.user_id)
          if commute_user != nil then
            user = Capri.find_by_full_name(commute_user.full_name)
            if user != nil then
              if !(a.include? user.id) then
                puts commuter.id.to_s + ' user id' + commuter.user_id.to_s + 'Capri id' + user.id.to_s + "no distance!"
              end
            end
          end
        end
      end
    end
  end
end