require "generator_spec"
require "rails/generators/task/task_generator"
require 'rails'

# ToDo(Abhishek) how to DRY this up?
describe TaskGenerator do
  destination File.expand_path("../../tmp", __FILE__)

  context "rails 4" do
    before(:context) do
      RSpec::Mocks.with_temporary_scope do
        prepare_destination
        allow(Rails).to receive(:version).and_return('4.2')
        run_generator ["users", "do_something"]
      end
    end

    before(:each) do
      time_to_test = Time.now
      allow(Time).to receive(:now).and_return(time_to_test)
      @timestamp = time_to_test.strftime("%Y%m%d%H%M%S")
      # we need to fetch the directory due to a substring of the filename being generated using random characters
      @all_files = Dir.entries("./spec/lib/tmp/lib/tasks/rake_migrations/users/").select {|f| !File.directory? f}  # https://stackoverflow.com/a/15511438
      @created_rake_file = @all_files.first
      puts @all_files
      puts "File name is #{@created_rake_file}"
      # puts @created_rake_file
    end

    it "should assert file is created" do
      expect(@all_files.count).to eq 1
    end

    it "should create a file from the timestamp and namespace" do
      assert_file "lib/tasks/rake_migrations/users/#{@created_rake_file}"
    end

    it "should have the namespace 'users'" do
      assert_file "lib/tasks/rake_migrations/users/#{@created_rake_file}", /namespace :users/
    end

    it "should have the task 'do_something'" do
      assert_file "lib/tasks/rake_migrations/users/#{@created_rake_file}", /task do_something:/
    end

    it "should have the RakeMigration update" do
      assert_file "lib/tasks/rake_migrations/users/#{@created_rake_file}", /RakeMigration.mark_complete/
    end
  end

  context "rails 5" do
    before(:context) do
      RSpec::Mocks.with_temporary_scope do
        prepare_destination
        allow(Rails).to receive(:version).and_return('5.1')
        run_generator ["users", "do_something"]
      end
    end

    before(:each) do
      time_to_test = Time.now
      allow(Time).to receive(:now).and_return(time_to_test)
      @timestamp = time_to_test.strftime("%Y%m%d%H%M%S")
      @all_files = Dir.entries("./spec/lib/tmp/lib/tasks/rake_migrations/users/").select {|f| !File.directory? f}
      @created_rake_file = @all_files.first
    end

    it "should have the RakeMigration update" do
      assert_file "lib/tasks/rake_migrations/users/#{@created_rake_file}", /RakeMigration.mark_complete/
    end
  end
end