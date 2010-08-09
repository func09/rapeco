require 'rails/generators'
require 'rails/generators/migration'

class FriendlyIdGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  MIGRATIONS_FILE = File.join(File.dirname(__FILE__), "..", "..", "generators", "friendly_id", "templates", "create_slugs.rb")

  class_option :"skip-migration", :type => :boolean, :desc => "Don't generate a migration for the slugs table"

  def copy_files(*args)
    migration_template MIGRATIONS_FILE, "db/migrate/create_slugs.rb" unless options["skip-migration"]
  end

  # Taken from ActiveRecord's migration generator
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

end