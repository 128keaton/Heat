namespace :setup do
  desc "TODO"
  task generate_env: :environment do
      cp '.env.example', '.env'
  end

end
