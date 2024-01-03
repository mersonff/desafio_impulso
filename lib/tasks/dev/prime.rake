if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: :environment do
      unless ActiveRecord::Base.connection.table_exists?("proponents")
        Rake::Task["db:setup"].invoke
      end

      include FactoryBot::Syntax::Methods

      create(:user, email: "test@test.com", password: "123456", password_confirmation: "123456")

      10.times do |i|
        create(:proponent, name: "Proponent #{i}", user: User.first)
      end
    end
  end
end
