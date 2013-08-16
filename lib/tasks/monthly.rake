namespace :monthly do

  desc 'Initialize month'
  task :init_month => :environment do
    a = DateTime.new(2012, 2, 1)
    for i in 1..19
      MonthlyEmission.create(:month => a)
      a = a >> 1
    end
  end

  desc 'Calculate monthly total distance traveled by user'
  task :calc_total_dist => :environment do


    #monthly.update_attribute :total_distance, total_dist
  end
end