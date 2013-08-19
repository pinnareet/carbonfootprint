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
    Commuter.all.each do |commute|
      if commute.distance != nil then
        date = commute.scan_date
        if date.month == 9 and date.year == 2012 then
          #monthly = MonthlyEmission.find_by_month(Date.new(date.year, date.month, 1))
          monthly = MonthlyEmission.find_by_month(Date.new(2012, 9, 1))
          old_dist = monthly.total_distance
          monthly.update_attribute :total_distance, old_dist + commute.distance
        end
      end
    end
  end

  desc 'Reset dist'
  task :reset => :environment do
    #monthly = MonthlyEmission.find_by_month(Date.new(2013,8,1))
    monthly.update_attribute :total_distance, 0
  end

  desc 'Count number of people in each month'
  task :count_ppl => :environment do
    RegisterDate.all.each do |date|
      date_inq = RegisterDate.date_obj.to_date
      monthly = MonthlyEmission.find_by_month(Date.new(date_inq.year, date_inq.month, 1))
      monthly.update_attribute :num_ppl, monthly.num_ppl + 1
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