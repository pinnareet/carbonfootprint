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
  task :getmonth => :environment do
    Commuter.all.each do |commute|
      commute.update_attribute :month, commute.scan_time[0,7]
    end
  end

  desc 'Delete data'
  task :delete, [:model] => :environment do |task, args|
    eval (args.model + '.destroy_all\n' +
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
  end
end