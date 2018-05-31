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
  task :match_ou_strings, [:file] => [:environment] do |task, args|
    puts "Running: #{task}"
    school_csv_text = File.read(args[:file])
    school_csv = CSV.parse(school_csv_text)
    school_csv.each do |school|
      School.where(name: school[0]).first.update(ou_string: school[1])
    end
  end
end

