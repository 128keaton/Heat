namespace :update do
  task :admin_ou => :environment do
    ActiveRecord::Base.logger.level = 1
    role = Role.find_by(name: "Administrator")
    Location.all.each do |location|
      unless Location.location_is_school(location)
        if (role_quantity = location.role_quantities.find_by(role: role))
          puts '-----------------------------'
          puts "Updating #{location.name} OU"
          puts "Old OU: #{role_quantity.ou ? role_quantity.ou.empty? : 'No OU Set'}"
          puts 'Successfully updated' if role_quantity.update(ou: 'OU=Rouge Objects,DC=mcsk12,DC=net')
          puts "New OU: #{role_quantity.ou ? role_quantity.ou : 'No OU Set'}"
          puts '-----------------------------'
        end
      end
    end
  end
end

