require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module RakeMigrations
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      copy_migration_template_based_on_rails_version

      # copying the Devops task template
      template("devops_rake_utils.rake", "lib/tasks/devops_rake_utils.rake")

    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number dirname
    end

    def write_to_post_merge_hook
      post_merge_file = ".git/hooks/post-merge"
      what_to_write = <<-TEXT
#{!File.exists?(post_merge_file) ? '#!/bin/sh' : ''}
ruby ./config/rake_migrations_check.rb
TEXT

      File.open(post_merge_file, 'a+') do |file|
        file.write(what_to_write) unless file.read.match(/rake_migrations_check/)
      end
      `chmod 777 #{post_merge_file}`
    end

    private
    def copy_migration_template_based_on_rails_version

      host_rails_version = Rails.version
      version_info = host_rails_version.split('.')

      major_version = version_info.first
      minor_version = version_info.second

      if major_version.to_i <= 4
        migration_template "migration_rails_on_and_before_v4.rb", "db/migrate/create_rake_migrations_table.rb"
      else
        @rails_major_minor_version = "[#{major_version}.#{minor_version}]"
        migration_template "migration_rails_after_v4.rb", "db/migrate/create_rake_migrations_table.rb",
                           rails_major_minor_version: @rails_major_minor_version

      end
    end

  end
end