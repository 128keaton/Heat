require 'csv'
namespace :generate do
  task :seed_file => :environment do
    ActiveRecord::Base.logger.level = 1
    School.order(:id).all.each do |school|
      puts "School.create(name: \"#{school.name}\", ou_string: \"#{school.ou_string}\", school_code: \"#{school.school_code}\", blended_learning: #{school.blended_learning}, quantity: #{school.quantity})"
    end
  end
end

namespace :update do
  desc 'rake update:match_ou_strings["/Users/keatonburleson/Documents/test.csv",0,1]'
  task :match_ou_strings, [:file, :col_name, :col_ou] => [:environment] do |task, args|
    puts task
    school_csv_text = File.read(args[:file])
    school_csv = CSV.parse(school_csv_text)
    school_csv.each do |school|
      School.where(name: school[args[:col_name].to_i].gsub(/\(.*\)/, '').strip!).first.update(ou_string: school[args[:col_ou].to_i])
    end
  end
end

