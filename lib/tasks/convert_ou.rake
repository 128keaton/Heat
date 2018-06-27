namespace :update do
  task :admin_ou => :environment do
    ActiveRecord::Base.logger.level = 1
    role = Role.find_by(name: "Administrator")
    Location.all.each do |location|
      unless Location.location_is_school(location)
        if (role_quantity = location.role_quantities.find_by(role: role))
          puts "#{location.name}: #{role_quantity.ou ? role_quantity.ou : 'No OU Set'}"
        end
      end
    end
  end
end

