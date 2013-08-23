namespace :count do
  #add num_ppl and accu_ppl to each table

  desc 'Initialize MonthlyStatus'
  task :init => :environment do
    months = Array.new()
    date = Date.new(2012, 2, 1)
    while (date <=> Date.new(2013, 9, 1)) == -1 do
      months << date
      date = date >> 1
    end
    for stat in 0..3
        for month in months
          MonthlyStatus.create(:status => stat, :month => month, :num_ppl => 0, :accu_num_ppl => 0, :avg_emission => 0)
        end
      end
    end

  desc 'Reset'
  task :reset => :environment do
    MonthlyStatus.all.each do |monthly|
      monthly.update_attribute :num_ppl, 0
      monthly.update_attribute :accu_num_ppl, 0
    end
  end
  desc 'Count monthly number of people in each status'
  task :num_ppl => :environment do
    RegisterDate.all.each do |date|
      name = User.find(date.id).full_name
      if name == 'NULL' then
        capri = Capri.find_by_mailing_address(User.find(date.id).mailing_address)
      else
        capri = Capri.find_by_full_name(name)
      end
      if capri != nil then
        date_inq = date.date_obj.to_date
        monthly = MonthlyStatus.find_by_month_and_status(Date.new(date_inq.year, date_inq.month, 1), capri.status)
        monthly.update_attribute :num_ppl, monthly.num_ppl + 1
      end
    end
  end

  desc 'Accumulate number of people'
  task :accu_ppl => :environment do
    date = Date.new(2012, 2, 1)
    for i in 0..3
      monthly = MonthlyStatus.find_by_month_and_status(date, i)
      monthly.update_attribute :accu_num_ppl, monthly.num_ppl
    end
    date = date >> 1
    while (date <=> Date.new(2013, 9, 1)) == -1 do
      for i in 0..3
        monthly = MonthlyStatus.find_by_month_and_status(date, i)
        monthly.update_attribute :accu_num_ppl, monthly.num_ppl + MonthlyStatus.find_by_month_and_status(date << 1, i).accu_num_ppl
      end
      date = date >> 1
    end
  end

  desc 'Calculate average distance'
  task :calc_avg_dist => :environment do
    Monthly.all.each do |monthly|
      monthly.update_attribute :avg_distance, monthly.total_distance/monthly.accu_num_ppl
    end
  end

  desc 'Calculate total emission for each status'
  task :emission => :environment do
    Status.all.each do |item|
      case item.cred_type
        when 0
          factor = 0.3712
        when 1
          factor = 0.3295
        else
          factor = 0.3247
      end
      monthly = MonthlyStatus.find_by_month_and_status(item.month, item.stat)
      monthly.update_attribute :emission, monthly.emission + item.distance*factor
    end
  end

  desc 'Calculate total emission'
  task :total_emission => :environment do
    MonthlyStatus.all.each do |item|
      monthly = MonthlyEmission.find_by_month(item.month)
      monthly.update_attribute :emission, monthly.emission + item.emission
    end
  end
end