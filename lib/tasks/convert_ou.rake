namespace :update do
  task :admin_ou => :environment do
    ActiveRecord::Base.logger.level = 1
    role = Role.find_by(name: "Administrator")
    Location.all.each do |location|
      unless Location.location_is_school(location)
        puts "#{location.name}: #{location.role_quantities.find_by(role: role).ou}"
      end
    end
  end
end

