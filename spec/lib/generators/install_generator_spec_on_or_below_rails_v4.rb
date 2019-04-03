require "generator_spec"
require "rails/generators/rake_migrations/install_generator"

describe RakeMigrations::InstallGenerator do
  destination File.expand_path("../../tmp", __FILE__)

  context "migration and postgresql" do

    before(:context) do
      RSpec::Mocks.with_temporary_scope do
        prepare_destination
        allow(Rails).to receive(:version).and_return('4.2')
        run_generator
      end
    end

    it "should create a migration" do
      assert_migration "db/migrate/create_rake_migrations_table.rb"
    end

    it "should create the rake_migrations table" do
      assert_migration "db/migrate/create_rake_migrations_table.rb", /create_table :rake_migrations/
    end

    it "should create the version column" do
      assert_migration "db/migrate/create_rake_migrations_table.rb", /t.string :version/
    end

    it "should copy the devop rakes util with RakeMigrations.check function call" do
      assert_file "lib/tasks/devops_rake_utils.rake", /RakeMigrations.check/
    end

  end
end