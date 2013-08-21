namespace :monthly do

  desc 'Initialize month'
  task :init_month => :environment do
    a = Date.new(2012, 2, 1)
    for i in 1..19
      MonthlyEmission.create(:month => a)
      a = a >> 1
    end
  end

  task :init_dist => :environment do
    MonthlyEmission.all.each do |monthly|
      monthly.update_attribute :total_distance, 0
      monthly.update_attribute :avg_distance, 0
      monthly.update_attribute :stat0_emission, 0
      monthly.update_attribute :stat1_emission, 0
      monthly.update_attribute :stat2_emission, 0
      monthly.update_attribute :stat3_emission, 0
      monthly.update_attribute :cred0_dist, 0
      monthly.update_attribute :cred1_dist, 0
      monthly.update_attribute :cred2_dist, 0
      monthly.update_attribute :cred3_dist, 0
      monthly.update_attribute :cred4_dist, 0
      monthly.update_attribute :prof_emission, 0
      monthly.update_attribute :stud_emission, 0
      monthly.update_attribute :staff_emission, 0
    end
  end

  desc 'Check nil commuter'
  task :check_commuter_month => :environment do

  end
  desc 'Calculate monthly total distance traveled by all users'
  task :calc_total_dist => :environment do
    for i in 1..8
      monthly = MonthlyEmission.find_by_month(Date.new(2013, i, 1))
      monthly.update_attribute :total_distance, 0
      Commuter.all.each do |commute|
        if commute.distance != nil then
          date = commute.scan_date
          if date.month == i and date.year == 2013 then
            #monthly = MonthlyEmission.find_by_month(Date.new(date.year, date.month, 1))
            old_dist = monthly.total_distance
            monthly.update_attribute :total_distance, old_dist + commute.distance
          end
        end
      end
    end
  end

  desc 'Reset dist'
  task :reset,[:model,:field] => :environment do |task, args|
  #task :reset => :environment do
    #monthly = MonthlyEmission.find_by_month(Date.new(2013,8,1))
      eval(args.model + '.all.each do |item|
      item.update_attribute :' + args.field + ', 0
    end')
    #Status.all.each do |stat|
    #  if stat.month != Date.new(2012,2,1) then
    #    stat.update_attribute :distance, 0
    #  end
    #end
  end

  desc 'Count number of people registered in each month'
  task :count_ppl => :environment do
    #a = Array.new()
    RegisterDate.all.each do |date|
      name = User.find(date.id).full_name
      if name == 'NULL' then
        capri = Capri.find_by_mailing_address(User.find(date.id).mailing_address)
      else
        capri = Capri.find_by_full_name(name)
      end
      if capri != nil then
        date_inq = date.date_obj.to_date
        monthly = MonthlyEmission.find_by_month(Date.new(date_inq.year, date_inq.month, 1))
        monthly.update_attribute :num_ppl, monthly.num_ppl + 1
      end
    end
  end
    #puts a

  desc 'Debugging code'
  task :debug => :environment do
    User.all.each do |user|
      if user.full_name == 'NULL' then
        puts "#{user.full_name} #{user.id} #{user.mailing_address}\n"
      end
    end
  end

  desc 'Fix Capri'
  task :fix => :environment do
    Capri.all.each do |capri|
      capri.update_attribute :mailing_address, capri.mailing_address.gsub(%r(/r/n),"\r\n")
    end
  end

  desc 'Debugging code'
  task :debug_capri => :environment do
    Capri.all.each do |user|
      if user.full_name == 'NULL' then
        puts "#{user.full_name} #{user.id} #{user.mailing_address}\n"
      end
    end
  end

  desc 'Accumulate number of people'
  task :accu_ppl => :environment do
    first = MonthlyEmission.find(1)
    first.update_attribute :accu_num_ppl, first.num_ppl
    for i in 2..19
      month = MonthlyEmission.find(i)
      month.update_attribute :accu_num_ppl, MonthlyEmission.find(i-1).accu_num_ppl + month.num_ppl
    end
  end

  desc 'Calculate average distance'
  task :calc_avg_dist => :environment do
    MonthlyEmission.all.each do |monthly|
      monthly.update_attribute :avg_distance, monthly.total_distance/monthly.accu_num_ppl
    end
  end
end