namespace :export do
  desc "Returns the seeds for the Schools."
  task :seeds_format => :environment do
    School.order(:id).all.each do |school|
      puts "School.create(name: \"#{school.name}\", ou_string: \"#{school.ou_string}\", school_code: \"#{school.school_code}\", blended_learning: #{school.blended_learning}, quantity: #{school.quantity})"
    end
  end
end