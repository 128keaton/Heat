require 'csv'
namespace :update do
  task :model => :environment do
    CSV.foreach(File.path('machines.csv')) do |row|
      unless row.nil?
        m = Machine.find_by(serial_number: row[0])
        m.update(model: row[1])
        m.print_label
      end
    end
  end
end


namespace :generate do
  task :seed_file => :environment do
    ActiveRecord::Base.logger.level = 1
    Location.order(:id).all.each do |school|
      puts "Location.create(name: \"#{school.name}\", ou_string: \"#{school.ou_string}\", school_code: \"#{school.school_code}\", blended_learning: #{school.blended_learning}, quantity: #{school.quantity})"
    end
  end
end

namespace :update do
  desc 'rake update:match_ou_strings["/Users/keatonburleson/Documents/test.csv",0,1]'
  task :match_ou_strings, [:file, :col_name, :col_ou] => [:environment] do |task, args|
    puts task
    ActiveRecord::Base.logger.level = 1
    school_csv_text = File.read(args[:file])
    school_csv = CSV.parse(school_csv_text, headers: true)
    school_csv.each do |school|
      if (@location = Location.where(name: school[args[:col_name].to_i].gsub(/\(.*\)/, '').strip!).first)
        @location.update(ou_string: school[args[:col_ou].to_i])
      else
        puts "Unable to find #{school[args[:col_name].to_i].gsub(/\(.*\)/, '').strip!}"
      end
    end
  end
end

