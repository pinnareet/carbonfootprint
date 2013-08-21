namespace :status do

  desc 'Initialize Status Table'
  task :init_stat => :environment do
    months = Array.new()
    date = Date.new(2012, 2, 1)
    while (date <=> Date.new(2013, 9, 1)) == -1 do
      months << date
      date = date >> 1
    end
    status = ['Bronze', 'Silver', 'Gold', 'Platinum']
    credit = ['Peak', 'Decongesting', 'Off-peak', 'Problem', 'Other']
    for stat in 0..3
      for cred_type in 0..4
          for month in months
            Status.create(:stat => stat, :stat_str => status[stat], :cred_type => cred_type, \
            :cred_type_str => credit[cred_type], :month => month, :distance => 0)
          end
      end
    end
  end

  desc 'Initialize Affiliation Table'
  task :init_affiliation => :environment do
    months = Array.new()
    date = Date.new(2012, 2, 1)
    while (date <=> Date.new(2013, 9, 1)) == -1 do
      months << date
      date = date >> 1
    end
    affiliation = ['Student', 'Faculty', 'Staff', 'Other']
    credit = ['Peak', 'Decongesting', 'Off-peak', 'Problem', 'Other']
    for type in affiliation
      for cred_type in 0..4
        for month in months
          Affiliation.create(:aff => type, :cred_type => cred_type, \
            :cred_type_str => credit[cred_type], :month => month, :distance => 0)
        end
      end
    end
  end

  desc 'Initialize Tables'
  task :init,[:model,:count,:array]=> :environment do |task, args|
    months = Array.new()
    date = Date.new(2012, 2, 1)
    while (date <=> Date.new(2013, 9, 1)) == -1 do
      months << date
      date = date >> 1
    end
    credit = ['Peak', 'Decongesting', 'Off-peak', 'Problem', 'Other']
    for stat in 0..args.count
      for cred_type in 0..4
        for month in months
          eval(args.model + '.create(:num => stat, :str => args.array[stat], :cred_type => cred_type, \
            :cred_type_str => credit[cred_type], :month => month, :distance => 0)')
        end
      end
    end
  end

  task :calc_dist => :environment do
    for i in 1..8
      Commuter.all.each do |commute|
        if commute.scan_date.month == i and commute.scan_date.year == 2013 then
          if commute.distance != nil and commute.user_id < 2554 then
            temp = User.find(commute.user_id)
            if temp != nil then
              user = Capri.find_by_full_name(temp.full_name)
              if user != nil then
                if user.full_name == 'NULL' then
                  user = Capri.find_by_mailing_address(temp.mailing_address)
                end
              end
              if user != nil then
                #date = commute.scan_date
                #if date.month == 2 and date.year == 2012 then
                status = Status.find_by_stat_and_cred_type_and_month(user.status, commute.credit_type, Date.new(commute.scan_date.year, commute.scan_date.month, 1))
                old_dist = status.distance
                status.update_attribute :distance, old_dist + commute.distance
                #end
              end
            end
          end
        end
      end
      puts i
    end
  end

  task :calc_dist_aff => :environment do
    for i in 1..8
      Commuter.all.each do |commute|
        if commute.scan_date.month == i and commute.scan_date.year == 2013 then
          if commute.distance != nil and commute.user_id < 2554 then
            temp = User.find(commute.user_id)
            if temp != nil then
              user = Capri.find_by_full_name(temp.full_name)
              if user != nil then
                if user.full_name == 'NULL' then
                  user = Capri.find_by_mailing_address(temp.mailing_address)
                end
              end
              if user != nil then
                #date = commute.scan_date
                status = Affiliation.find_by_aff_and_cred_type_and_month(user.affiliation, commute.credit_type, Date.new(commute.scan_date.year, commute.scan_date.month, 1))
                old_dist = status.distance
                status.update_attribute :distance, old_dist + commute.distance
              end
            end
          end
        end
      end
      puts i
    end
  end
end